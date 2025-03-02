//
//  GraphicView2.swift
//  Waterly
//
//  Created by Sena Çırak on 9.01.2025.
//

import SwiftUI
import Charts

struct GraphicView2: View {
    @ObservedObject var user: UserModel
    @State private var selectedInterval = "Weekly"
    let intervals = ["Weekly", "Yearly"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Water Intake Statistics")
                .font(.title)
                .bold()
                .padding()
            
            Picker("Select Interval", selection: $selectedInterval) {
                ForEach(intervals, id: \ .self) { interval in
                    Text(interval)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if selectedInterval == "Weekly" {
                VStack{
                    HStack{
                        Button{
                            
                        }label: {
                            Image(systemName: "chevron.left")
                        }
                        Text("")
                        Button{
                            
                        }label: {
                            Image(systemName: "chevron.right")
                        }
                        
                    }
                    DailyWaterChart(user: user)
                }
                
            }
//            else if selectedInterval == "Monthly" {
//                MonthlyWaterChart(user: user)
//            }
            else {
                YearlyWaterChart(user: user)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct DailyWaterChart: View {
    @ObservedObject var user: UserModel
    
    var body: some View {
        let data = weeklyData()
        Chart {
            ForEach(data, id: \ .date) { data in
                BarMark(
                    x: .value("Day", data.day),
                    y: .value("Water", data.amount)
                )
                .foregroundStyle(data.amount >= user.dailyGoal ? Color.green.gradient : Color.blue.gradient)
                .cornerRadius(7)
                .annotation(position: .top) {
                    Text("\(Int(data.amount)) ml").font(.caption).foregroundStyle(.gray)
                }
            }
        }
        .frame(height: 230)
        .chartXAxis{
            AxisMarks{ mark in
                AxisValueLabel()
            }
        }
        .chartYAxis{
            AxisMarks{ mark in
                AxisValueLabel()
            }
        }
        .padding()
    }
    
    func weeklyData() -> [(day: String, amount: Double, date: Date)] {
        let calendar = Calendar.current
        var data: [(String, Double, Date)] = []
        
        for offset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: offset, to: Date().startOfWeek!) {
                let records = user.fetchRecords(for: date)
                let totalAmount = records.reduce(0) { $0 + $1.amount }
                let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                data.append((dayName, totalAmount, date))
            }
        }
        return data
    }
}

//struct MonthlyWaterChart: View {
//    @ObservedObject var user: UserModel
//    
//    var body: some View {
//        let data = monthlyData()
//        Chart {
//            ForEach(data, id: \ .date) { data in
//                BarMark(
//                    x: .value("Day", data.day),
//                    y: .value("Water", data.amount)
//                )
//                .foregroundStyle(Color.blue.gradient)
//                .cornerRadius(7)
//            }
//        }
//        .frame(height: 230)
//        .padding()
//    }
//    
//    func monthlyData() -> [(day: String, amount: Double, date: Date)] {
//        let calendar = Calendar.current
//        var data: [(String, Double, Date)] = []
//        
//        for offset in 0..<30 {
//            if let date = calendar.date(byAdding: .day, value: offset, to: Date().startOfMonth!) {
//                let records = user.fetchRecords(for: date)
//                let totalAmount = records.reduce(0) { $0 + $1.amount }
//                let dayNumber = calendar.component(.day, from: date)
//                data.append((String(dayNumber), totalAmount, date))
//            }
//        }
//        return data
//    }
//}

struct YearlyWaterChart: View {
    @ObservedObject var user: UserModel
    
    var body: some View {
        let data = yearlyData()
        Chart {
            ForEach(data, id: \ .date) { data in
                BarMark(
                    x: .value("Month", data.month),
                    y: .value("Water", data.amount)
                )
                .foregroundStyle(Color.pink.gradient)
                .cornerRadius(7)
            }
        }
        .frame(height: 230)
        .chartXAxis{
            AxisMarks{ mark in
                AxisValueLabel()
            }
        }
        .chartYAxis{
            AxisMarks{ mark in
                AxisValueLabel()
            }
        }
        .padding()
    }
    
    func yearlyData() -> [(month: String, amount: Double, date: Date)] {
        let calendar = Calendar.current
        var data: [(String, Double, Date)] = []
        
        for offset in 0..<12 {
            if let date = calendar.date(byAdding: .month, value: offset, to: Date().startOfYear!) {
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

//    var startOfMonth: Date? {
//        let calendar = Calendar.current
//        return calendar.date(from: calendar.dateComponents([.year, .month], from: self))
//    }

    var startOfYear: Date? {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.year], from: self))
    }
}

#Preview {
    GraphicView2(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
