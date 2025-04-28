//
//  DailyRecordsView.swift
//  Waterly
//
//  Created by Sena Çırak on 30.12.2024.
//

import SwiftUI

struct DailyRecordsView: View {
    
    @ObservedObject var user: UserModel
    var filterDate: Date
    
    @State private var selectedRecord: WaterRecord?
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        let filteredRecords = user.fetchRecords(for: filterDate)
            .sorted(by: {$0.date ?? Date() > $1.date ?? Date() })
        ScrollView {
            VStack(spacing: -40) {
                ForEach(filteredRecords, id: \.self) { record in
                    ZStack {
                        HStack {
                            Image(systemName: "drop.fill")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color.blue)
                            
                            VStack(alignment: .leading) {
                                Text("\(Int(record.amount)) mL")
                                    .font(.system(size: 19, weight: .medium, design: .rounded))
                                    .foregroundStyle(.primary)
                                
                                Text(record.date?.formatted(date: .omitted, time: .shortened) ?? "Unknown time")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                            
                            Spacer()
                            
                            Button {
                                selectedRecord = record
                                showDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .confirmationDialog("delete", isPresented: $showDeleteConfirmation) {
            Button("delete", role: .destructive) {
                if let recordToDelete = selectedRecord {
                    user.deleteRecord(recordToDelete)
                    selectedRecord = nil
                    user.updateProgress()
                }
            }
        }
    }
}

#Preview {
    DailyRecordsView(user: UserModel(context: PersistenceController.shared.container.viewContext), filterDate: Date())
}
