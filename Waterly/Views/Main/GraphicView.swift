//
//  GraphicView2.swift
//  Waterly
//
//  Created by Sena Çırak on 9.01.2025.
//

import SwiftUI
import Charts

struct GraphicView: View {
    @ObservedObject var user: UserModel
    @State private var selectedInterval = "weekly_title"
    let intervals = ["weekly_title", "yearly_title"]
    @State private var currentWeekStart = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    
    var currentWeekEnd: Date {
        Calendar.current.date(byAdding: .day, value: 6, to: currentWeekStart)!
    }
    var formattedWeekRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return "\(dateFormatter.string(from: currentWeekStart)) - \(dateFormatter.string(from: currentWeekEnd))"
    }
    @State private var currentYear = Calendar.current.component(.year, from: Date())
    
    var formattedYearRange: String {
        "\(currentYear)"
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(spacing: 20) {
                    
                    Picker("Select Interval", selection: $selectedInterval) {
                        ForEach(intervals, id: \.self) { interval in
                            Text(LocalizedStringKey(interval))
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedInterval == "weekly_title" {
                        VStack {
                            HStack {
                                Button {
                                    previousWeek()
                                } label: {
                                    Image(systemName: "chevron.left")
                                }
                                
                                Text(formattedWeekRange)
                                    .font(.headline)
                                
                                Button {
                                    nextWeek()
                                } label: {
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .padding(.bottom)
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.white)
                                    .shadow(radius: 10)
                                    .frame(width: 360,height: 280)
                                DailyWaterChart(user: user, startDate: currentWeekStart)
                                
                            }
                        }
                    } else {
                        VStack {
                            HStack {
                                Button { previousYear()} label: { Image(systemName:"chevron.left") }
                                
                                Text(formattedYearRange)
                                    .font(.headline)
                                
                                Button { nextYear() } label: { Image(systemName: "chevron.right") }
                            }
                            .padding(.bottom)
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.white)
                                    .shadow(radius: 10)
                                    .frame(width: 360,height: 280)
                                YearlyWaterChart(user: user, year: currentYear)
                                
                            }
                        }
                    }
                    Spacer()
                    VStack{
                        Text("\(Int(user.bestDayAmount)) ml")
                        Text("\(user.bestDayAmountDate)")

                    }
                }
                .padding()
                .padding(.top,10)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Text("statistics_title")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .padding(.top,15)
                    }
                }
            }
            
        }
    }
    
    func previousWeek() {
        currentWeekStart = Calendar.current.date(byAdding: .day, value: -7, to: currentWeekStart)!
    }
    
    func nextWeek() {
        currentWeekStart = Calendar.current.date(byAdding: .day, value: 7, to: currentWeekStart)!
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
        .frame(height: 230)
        .chartXAxis {
            AxisMarks { mark in AxisValueLabel() }
        }
        .chartYAxis {
            AxisMarks { mark in AxisValueLabel()
            }
        }
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
                data.append((dayName,totalAmount, date))
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
        .frame(height: 230)
        .chartXAxis {
            AxisMarks { mark in
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks { mark in
                AxisValueLabel()
            }
        }
        .padding()
    }
    
    func yearlyData(for year: Int) -> [(month: String, amount: Double, date: Date)] {
        let calendar = Calendar.current
        var data: [(String, Double, Date)] = []
        
        for month in 1..<13 {
            if let date = calendar.date(from: DateComponents(year: year,month: month, day: 1)) {
                let records = user.fetchRecords(for: date)
                let totalAmount = records.reduce(0) { $0 + $1.amount }
                let monthName = calendar.shortMonthSymbols[calendar.component(.month, from: date) - 1]
                data.append((monthName, totalAmount, date))
            }
        }
        return data
    }
}

extension Date {
    var startOfWeek: Date? {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    }

    var startOfYear: Date? {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.year], from: self))
    }
}


#Preview {
    GraphicView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
