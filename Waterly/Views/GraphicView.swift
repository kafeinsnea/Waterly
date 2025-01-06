//
//  GraphicView.swift
//  Waterly
//
//  Created by Sena Çırak on 19.12.2024.
//

import SwiftUI
import Charts

struct GraphicView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var user: UserModel
    
    @State private var selectedInterval = "Weekly"
    var intervals = [ "Weekly", "Monthly"]
    
    @State private var selectedDate: Date? = nil
    @State private var records: [WaterRecord] = []
    
    var body: some View {
        VStack {
            Picker("Interval", selection: $selectedInterval) {
                ForEach(intervals, id: \.self) { interval in
                    Text(interval)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Chart{
                if selectedInterval == "Weekly" {
                    ForEach(weeklyData(), id: \.day){ data in
                        BarMark(
                            x: .value("Day",data.day),
                            y: .value("ml", data.amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .annotation(position: .top) {
                            Text("\(Int(data.amount)) ml")
                                .font(.caption)
                                .foregroundStyle(Color.blue)
                        }
                    }
                } else{
                    ForEach(monthlyData(),id: \.day){ data in
                        BarMark(
                            x: .value("Day", data.day),
                            y: .value("ml", data.amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .annotation(position: .top) {
                            Text("\(Int(data.amount)) ml")
                                .font(.caption)
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
            }
            .chartYAxis{
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .automatic)
            }
            .frame(height:300)
            .padding()
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
    GraphicView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
