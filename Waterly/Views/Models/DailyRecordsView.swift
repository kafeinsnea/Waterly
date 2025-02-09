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
        ScrollView {
            VStack(spacing: -15){
                ForEach(filteredRecords, id: \.self){ record in
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 350, height: 70)
                            .foregroundStyle(Color.blue)
                        
                        HStack {
                            
                            Image(systemName: "mug")
                                .font(.title)
                                .foregroundStyle(Color.white)
                            
                            VStack(alignment:.leading){
                                
                                Text("\(Int(record.amount)) ml")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                Text(record.date?.formatted(date:.omitted, time: .shortened) ?? "unknown time")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                            }
                            
                            .padding()
                            .foregroundStyle(Color.white)
                            Spacer()
                            
                            Button{
                                selectedRecord = record
                                showDeleteConfirmation = true
                            }label:{
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color.white)
                                    .font(.title)
                            }
                           
                        }
                        .padding(.horizontal,50)
                       
                    }
                    .padding()
                }
                
            }
        }
        .confirmationDialog("Delete", isPresented: $showDeleteConfirmation) {
            Button("delete", role:.destructive){
                if let recordToDelete = selectedRecord{
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
