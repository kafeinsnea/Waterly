//
//  GraphicView.swift
//  Waterly
//
//  Created by Sena Çırak on 19.12.2024.
//


import SwiftUI

struct GraphicView: View {
    
    @ObservedObject var user: UserModel
    @State private var selectedDay: String? = nil // Haftanın seçili günü
    @State private var currentWeek: [Date] = [] // Haftanın günleri
    
    init(user: UserModel) {
        self.user = user
        self._currentWeek = State(initialValue: GraphicView.getCurrentWeek())
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Üst başlık
            Text("This Week")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            
            // Haftalık çubuklar
            HStack(spacing: 16) {
                ForEach(currentWeek, id: \.self) { date in
                    let dayName = getDayName(from: date)
                    let dailyRecords = user.fetchRecords(for: date)
                    let totalAmount = dailyRecords.reduce(0) { $0 + $1.amount }
                    
                    
                        VStack {
                            ZStack(alignment: .bottom) {
                                // Boş çubuk arka planı
                                Capsule()
                                    .fill(Color.white.opacity(0))
                                    .frame(width: 30, height: 200)
                                
                                // Dolu kısım (veriye göre)
                                Capsule()
                                    .fill(selectedDay == dayName ? Color.blue : Color.cyan)
                                    .frame(width: 30, height: CGFloat(totalAmount) / CGFloat(getMaxAmount()) * 200)
                                if totalAmount > 0 {
                                    Text(getEmoji(from: totalAmount))
                                        .font(.title)
                                        .offset(y: -CGFloat(totalAmount) / CGFloat(getMaxAmount()) * 200 - -33)
                                }
                               
                            }
                            
                            .onTapGesture {
                                selectedDay = dayName
                            }
                            
                            // Gün adı
                            Text(dayName)
                                .font(.caption)
                                .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal)
            
            // Seçili güne ait veri detayları
            if let day = selectedDay {
                let selectedDate = currentWeek.first { getDayName(from: $0) == day }
                let dailyRecords = selectedDate != nil ? user.fetchRecords(for: selectedDate!) : []
                let totalAmount = dailyRecords.reduce(0) { $0 + $1.amount }
                
                Text("\(day): \(totalAmount) ml")
                    .font(.headline)
                    .padding(.top)
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    // Haftanın günlerini hesaplama
    static func getCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekRange = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let weekStart = calendar.date(byAdding: .day, value: -(calendar.component(.weekday, from: today) - 1), to: today)!
        return weekRange.compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset - 1, to: weekStart)
        }
    }
    
    // Haftanın maksimum miktarını bulma
    func getMaxAmount() -> Int {
        currentWeek.reduce(0) { maxAmount, date in
            let dailyRecords = user.fetchRecords(for: date)
            let totalAmount = dailyRecords.reduce(0) { $0 + $1.amount }
            return max(maxAmount, Int(totalAmount))
        }
    }
    
    // Gün adı oluşturma
    func getDayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Örneğin: "Sun", "Mon"
        return formatter.string(from: date)
    }
    
    func getEmoji(from totalAmount: Double) -> String {
        let dailyGoal = user.dailyGoal
        if totalAmount < 1000 {
            return "😕"
        } else if totalAmount <= dailyGoal {
            return "😊"
        } else {
            return "🥳"
        }
    }
}


    #Preview {
        GraphicView(user: UserModel(context: PersistenceController.shared.container.viewContext))
    }
