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
            VStack(spacing: -35){
                ForEach(filteredRecords, id: \.self){ record in
                    ZStack {
                        
//                        RoundedRectangle(cornerRadius: 15)
//                            .frame(width: 350, height: 70)
//                            .foregroundStyle(Color.blue)
                        
                        HStack {
                            
                            Image(systemName: "drop.fill")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color(#colorLiteral(red: 0.3527679443, green: 0.6399899125, blue: 0.9096029401, alpha: 1)))
                            
                            VStack(alignment:.leading){
                                
                                Text("\(Int(record.amount)) ml")
                                    .font(.system(size: 21, weight: .bold, design: .rounded))
                                Text(record.date?.formatted(date:.omitted, time: .shortened) ?? "unknown time")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                            .padding()
//                            .foregroundStyle(Color.white)
                            Spacer()
                            
                            Button{
                                selectedRecord = record
                                showDeleteConfirmation = true
                            }label:{
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color.black)
                                    .font(.title2)
                            }
                           
                        }
//                        .padding(.horizontal,10)
                       
                    }
                    .padding()
                }
                
            }
        }
        .confirmationDialog("Delete", isPresented: $showDeleteConfirmation) {
            Button("Delete", role:.destructive){
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
