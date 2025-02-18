//
//  AddingView.swift
//  Waterly
//
//  Created by Sena Çırak on 13.02.2025.
//

import SwiftUI

struct AddingView: View {
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    @State private var isSheetPresented = false
    @State private var lastAddedAmount: Double = 0
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 365,height:470)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 13)
                VStack(spacing:6) {
                    WaveView(progress: Binding(
                        get: { CGFloat(user.waterConsumed / max(1, user.dailyGoal)) },
                        set: { newProgress in
                            withAnimation(.easeInOut(duration: 4)) {
                                user.waterConsumed = min(Double(newProgress) * user.dailyGoal, user.dailyGoal)
                            }
                        }
                    ))
                    
                        Text("\(Int(user.waterConsumed)) mL")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                  
                    Text("Daily Goal : \(Int(user.dailyGoal)) mL")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                    
                    Button{
                        user.removeLastAddedWater()
                    }label: {
                        Image(systemName: "minus")
                            .foregroundStyle(Color.white)
                            .background(Circle().fill(Color.red).frame(width: 50,height: 50))
                    }
               
//
//                                                        Button( "Reset Progress") {
//                                                            user.resetProgress()
//                                                        }
                }
            }
            
            //                ButtonView(title: "250 ml") {
            //                    user.addWater(amount: 250)
            //                    user.updateProgress()
            //                }
            //                Button{
            //                    isSheetPresented = true
            //                }label: {
            //                    Image(systemName: "plus")
            //                        .foregroundStyle(Color.red)
            //                        .background(Circle().stroke(style: StrokeStyle(lineWidth: 3)).foregroundColor(Color.blue).frame(width: 50, height: 50))
            //                }
            //                .sheet(isPresented: $isSheetPresented) {
            //                    SwitchCupView(user: user, selectedCupSize: $selectedCupSize)
            //                        .presentationDetents([.medium, .large])
            //                        .presentationDragIndicator(.visible)
            ////                        .interactiveDismissDisabled()
            //                }
            
           
                Text("Add Water")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.top,17)
                    .padding(.horizontal,25)
          
                        ButtonView(title: "250 ml") {_ in 
                            user.addWater(amount: 250)
                            user.updateProgress()
                        }
        }
    }
}

#Preview {
    AddingView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
