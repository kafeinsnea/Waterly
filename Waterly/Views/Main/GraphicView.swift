//
//  GraphicView.swift
//  Waterly
//
//  Created by Sena Çırak on 9.01.2025.
//

import SwiftUI
import CoreData
import Charts

struct GraphicView: View {
    @ObservedObject var user: UserModel
    @State private var selectedInterval = "weekly_title"
    let intervals = ["weekly_title","monthly_title", "yearly_title"]
    @State private var currentWeekStart = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    @State private var currentMonth = Calendar.current.component(.month, from: Date())
    @State private var currentMonthYear = Calendar.current.component(.year, from: Date())
    var formattedYearRange: String {
        "\(currentYear)"
    }
    var formattedYearRange2: String {
        "\(currentMonthYear)"
    }
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(spacing: 30) {
                    Picker("Select Interval", selection: $selectedInterval) {
                        ForEach(intervals, id: \.self) { interval in
                            Text(LocalizedStringKey(interval))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if selectedInterval == "weekly_title" {
                        VStack {
                            ZStack{
                                DailyWaterChart(user: user, startDate: currentWeekStart)
                            }
                        }
                    } else if selectedInterval == "monthly_title"{
                        VStack {
                            HStack {
                                Button { previousMonth()} label: { Image(systemName:"chevron.left")
                                        .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
                                }
                                
                                Text("\(monthName(for : currentMonth)) \(formattedYearRange2)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                
                                Button { nextMonth() } label: { Image(systemName: "chevron.right")
                                        .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
                                }
                            }
                            .padding(.vertical)
                                MonthlyWaterChart(user: user, monthStart: monthStartDate())
                            
                        }
                    } else {
                        VStack {
                            HStack {
                                Button { previousYear()} label: { Image(systemName:"chevron.left")
                                        .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
                                }
                                
                                Text(formattedYearRange)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                
                                Button { nextYear() } label: { Image(systemName: "chevron.right")
                                        .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
                                }
                            }
                            .padding(.vertical)
                            
                                YearlyWaterChart(user: user, year: currentYear)
                           
                        }
                    }
                    
                    Text("\(Text(LocalizedStringKey("bestday"))): \(user.bestDayAmountDate) - \(Int(user.bestDayAmount)) ml 🏆")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.indigo)
                        .padding()
                    
                    Spacer()
                    
                }
                .padding()
                .padding(.top,10)
                .navigationTitle(Text("statistics_title"))
                .background(Color.gray.opacity(0.05).ignoresSafeArea())
            }
        }
    }
    
    func monthName (for month: Int) -> String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[month - 1]
    }
    func monthStartDate() -> Date {
        Calendar.current.date(from: DateComponents(year: currentMonthYear,month: currentMonth,day: 1))!
    }
    func previousMonth(){
        if currentMonth == 1 {
            currentMonth = 12
            currentMonthYear -= 1
        }
        else{
            currentMonth -= 1
        }
    }
    
    func nextMonth(){
        if currentMonth == 12 {
            currentMonth = 1
            currentMonthYear += 1
        }
        else{
            currentMonth += 1
        }
    }
    func previousYear() {
        currentYear -= 1
    }
    func nextYear() {
        currentYear += 1
    }
}

struct DailyWaterChart: View {
    @ObservedObject var user: UserModel
    var startDate: Date

    var body: some View {
        let data = weeklyData()
        Chart {
            ForEach(data, id: \.date) { data in
                RuleMark(y: .value("dailygoal", user.dailyGoal))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [7]))
                    .foregroundStyle(Color.mint)
                    .annotation(position: .top, alignment: .leading) {
                        Text("\(Text(LocalizedStringKey("dailygoal"))): \(Int(user.dailyGoal)) mL")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                BarMark(
                    x: .value("Day", data.day),
                    y: .value("Water", data.amount)
                )
                .foregroundStyle(data.amount >= user.dailyGoal ? Color.green.gradient : Color.blue.gradient)
                .cornerRadius(7)
                .annotation(position: .top) {
                    Text("\(Int(data.amount)) mL")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
//        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 7)
        .frame(height: 230)
//        .chartXAxis {
//            AxisMarks { mark in AxisValueLabel() }
//        }
//        .chartYAxis {
//            AxisMarks { mark in AxisValueLabel() }
//        }
        .padding()
    }

    func weeklyData() -> [(day: String, amount: Double, date: Date)] {
        let calendar = Calendar.current
        var data: [(String, Double, Date)] = []
        
        for offset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: offset, to: startDate) {
                let records = user.fetchRecords(for: date)
                let totalAmount = records.reduce(0) { $0 + $1.amount }
                let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                data.append((dayName, totalAmount, date))
            }
        }
        return data
    }
}

struct YearlyWaterChart: View {
    @ObservedObject var user: UserModel
    var year: Int
    var body: some View {
        let data = yearlyData(for: year)
        Chart {
            ForEach(data, id: \.date) { data in
                BarMark(
                    x: .value("Month", data.month),
                    y: .value("Water", data.amount)
                )
                .foregroundStyle(Color.pink.gradient)
                .cornerRadius(7)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.1))
                AxisTick().foregroundStyle(.gray.opacity(0.2))
                AxisValueLabel().foregroundStyle(.gray)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.1))
                AxisTick().foregroundStyle(.gray.opacity(0.2))
                AxisValueLabel().foregroundStyle(.gray)
            }
        }
        .frame(height: 230)
//        .chartXAxis {
//            AxisMarks { mark in
//                AxisValueLabel()
//            }
//        }
//        .chartYAxis {
//            AxisMarks { mark in
//                AxisValueLabel()
//            }
//        }
        .padding()
    }
    
    func yearlyData(for year: Int) -> [(month: String, amount: Double, date: Date)] {
        let calendar = Calendar.current
        var data: [(String, Double, Date)] = []
        
        for month in 1..<13 {
            if let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
                let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
                _ = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth)!
                
                let records = user.fetchRecordsForYear(year: year).filter { record in
                    let recordDate = record.date ?? Date()
                    return calendar.isDate(recordDate, equalTo: startOfMonth, toGranularity: .month)
                }
                let totalAmount = records.reduce(0) { $0 + $1.amount }
                
                let monthName = calendar.shortMonthSymbols[calendar.component(.month, from: startOfMonth) - 1]
                data.append((monthName, totalAmount, startOfMonth))
            }
        }
        return data
    }
}

struct MonthlyWaterChart: View {
    @ObservedObject var user: UserModel
    var monthStart: Date
    @State private var selectedData: (day: String, amount: Double)?
    
    var body: some View {
        let data = monthlyData()
        VStack(alignment: .leading) {
            Chart {
                ForEach(data, id: \.date) { dataItem in
                    BarMark(
                        x: .value("Day", dataItem.dayNumber),
                        y: .value("Amount", dataItem.amount)
                    )
                    .foregroundStyle(dataItem.amount >= user.dailyGoal ? Color.green.gradient : Color.blue.gradient)
                    .cornerRadius(5)
                }
            }
            .chartXAxis{
                AxisMarks(values: [7,14,21,28]) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel{
                        if let intVal = value.as(Int.self){
                            Text("\(intVal)")
                        }
                    }
                }
            }
            .chartXVisibleDomain(length: 30)
            .frame(height: 230)
            .padding()
        }
    }
    
    func monthlyData() -> [(dayNumber: Int, amount: Double, date: Date)] {
        let calendar = Calendar.current
        var data: [(Int, Double, Date)] = []
        
        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                let records = user.fetchRecords(for: date)
                let totalAmount = records.reduce(0) { $0 + $1.amount }
                
                data.append((day, totalAmount, date))
            }
        }
        
        return data
    }
    
}


//extension Date {
//    var startOfWeek: Date? {
//        let calendar = Calendar.current
//        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
//    }
//
//    var startOfYear: Date? {
//        let calendar = Calendar.current
//        return calendar.date(from: calendar.dateComponents([.year], from: self))
//    }
//}


#Preview {
    GraphicView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
