//
//  GraphicView2.swift
//  Waterly
//
//  Created by Sena Çırak on 9.01.2025.
//

import SwiftUI
import Charts

struct GraphicView2: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var user: UserModel
    @State private var selectedInterval = "Weekly"
 
    var intervals = ["Weekly", "Monthly"]
    
    @State private var records: [WaterRecord] = []
    
    var body: some View {
        VStack {
            Picker("ss", selection: $selectedInterval) {
                ForEach(intervals, id: \.self) { interval in
                    Text(interval)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if selectedInterval == "Weekly" {
                Chart {
                    ForEach(weeklyData(), id: \.date){ data in
                        BarMark(x: .value("h", data.day), y: .value("n", data.amount))
                            .foregroundStyle(Color.blue.gradient)
                            .cornerRadius(10)
                            .annotation(position: .top) {
                                Text("\(Int(data.amount)) ml")
                                    .font(.caption)
                                    .foregroundStyle(Color.blue)
                            }
                    }
                }
                .padding()
                .frame(height:300)
                
            } else if selectedInterval == "Monthly" {
                Chart {
                    ForEach(monthlyData(),id: \.date){ data in
                        BarMark(x: .value("h", data.day), y: .value("n", data.amount))
                    }
                }
                .padding()
                .frame(height:300)
            }
        }
    }
    func fetchRecords(for date: Date){
          records = user.fetchRecords(for: date)
      }
    
    func weeklyData() -> [(day: String, amount: Double, date: Date)] {
            let calendar = Calendar.current
            let today = Date()
            var data: [(String, Double, Date)] = []
            
            for offset in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: -offset, to: today) {
                    let records = user.fetchRecords(for: date)
                    let totalAmount = records.reduce(0) { $0 + $1.amount }
                    let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
                    data.append((dayName, totalAmount, date))
                }
            }
            
            return data.reversed()
        }
        
        func monthlyData() -> [(day: Int, amount: Double, date: Date)] {
            let calendar = Calendar.current
            let today = Date()
            var data: [(Int, Double, Date)] = []
            
            for offset in 0..<30 {
                if let date = calendar.date(byAdding: .day, value: -offset, to: today) {
                    let records = user.fetchRecords(for: date)
                    let totalAmount = records.reduce(0) { $0 + $1.amount }
                    let dayNumber = calendar.component(.day, from: date)
                    data.append((dayNumber, totalAmount, date))
                }
            }
            
            return data.reversed()
        }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    GraphicView2(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
