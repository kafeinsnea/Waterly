//
//  HomeView.swift
//  Waterly
//
//  Created by Sena Çırak on 16.12.2024.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    @State private var navigateToAddingView = false
    @State private var showAlert = false
    @State private var isSheetPresented = false
    @State private var selectedCupSize: Int? = nil
    @State private var isSwitchCupSheetPresented = false

    var progress: CGFloat {
        return min(user.waterConsumed / user.dailyGoal, 1.0)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 9) {
                    Text("Today's Goal")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                    Text("\(Int(user.dailyGoal))")
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(Color("yazıRengi"))
                        .padding(.bottom)

                    ZStack {
                        Circle()
                            .stroke(Color("grayStroke").opacity(0.7), lineWidth: 16)
                        
                        Circle()
                            .trim(from: 0.0, to: progress)
                            .stroke(Color("tamamlanan"),style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        
                        VStack {
                            Text("\(user.progressPercentage)%")
                                .font(.system(size: 31, weight: .bold, design: .rounded))
                                .foregroundStyle(Color("yazıRengi"))
                            Text("\(Int(user.waterConsumed)) mL Drunk")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundStyle(Color("yazıRengi"))
                        }
                    }
                    .frame(width: 180, height: 180)

//                    HStack(spacing:45){
                        Button(action: {
                            isSheetPresented = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20,weight: .bold))
                                .frame(width: 60, height: 60)
                                .background(Color("button"))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(color: .gray.opacity(0.4), radius: 10,x:0,y:4)
                                .scaleEffect(isSheetPresented ? 0.95 : 1.0)
                                .animation(.spring(), value: isSheetPresented)
                                .accessibilityLabel("Add Water")
                        }
                        .sheet(isPresented: $isSheetPresented) {
                            SwitchCupView(user: user, selectedCupSize: $selectedCupSize)
                                .presentationDetents([.fraction(0.5)])

//                            CustomAmountSheet(isPresented: $isSheetPresented, user: user)
                        }
                        .presentationDetents([.medium])
                        .padding(8)
                        
//                        Button {
//                            showAlert = true
//                        } label: {
//                            Image(systemName: "arrow.uturn.backward.circle.fill")
//                                .font(.system(size: 20,weight: .bold))
//                            .frame(width: 60, height: 60)
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .clipShape(Circle())
//                            .shadow(color: .gray.opacity(0.4), radius: 10,x:0,y:4)
//                        }
//                        .alert("Remove last added water?", isPresented: $showAlert) {
//                            Button("Cancel", role: .cancel) {}
//                            Button("Remove", role: .destructive) {
//                                user.removeLastAddedWater()
//                            }
//                        }
//                    }
//                    .padding()
                    
                    VStack(spacing: -8) {
                        Text("todays_records")
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundStyle(Color("başlık"))
                            .frame(maxWidth:360, alignment: .leading)
                        
                        DailyRecordsView(user: user, filterDate: Date())
                    }
                }
            }
            .navigationTitle(Text("\(Text(LocalizedStringKey("hello"))), \(user.username.isEmpty ? "Guest" : user.username) 👋"))
            .padding()
        }
    }
}

#Preview {
    HomeView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
