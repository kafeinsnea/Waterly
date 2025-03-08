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
    @State private var showAlert = false
    @State private var selectedAmount: Double = 250
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .frame(width: 350, height: 450)
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
                    
                        Text("\(Text(LocalizedStringKey("dailygoal"))): \(Int(user.dailyGoal)) mL")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.gray)
                    
                    Button {
                        showAlert = true
                    } label: {
                        Text("undolast")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.red)
                        .frame(height:40)
                        .cornerRadius(15)
                    }
                    .padding(20)
                    .alert("Remove last added water?", isPresented: $showAlert) {
                        Button("cancel", role: .cancel) {}
                        Button("Remove", role: .destructive) {
                            user.removeLastAddedWater()
                        } }
                    
                    //
                    //                                                        Button( "Reset Progress") {
                    //                                                            user.resetProgress()
                    //                                                        }
                }
            }
//            VStack(spacing: 15) {
//                Text("Add Water")
//                    .font(.system(size: 22, weight: .bold, design: .rounded))
//                    .padding(.bottom, 5)
//                
//                Slider(value: $selectedAmount, in: 100...1000, step: 50)
//                    .accentColor(.blue)
//                    .padding(.horizontal, 30)
//                
//                Text("\(Int(selectedAmount)) mL")
//                    .font(.title2.bold())
//                    .padding(.top, 5)
//                
//                Button(action: {
//                    user.addWater(amount: selectedAmount)
//                    user.saveUserData()
//                    user.updateProgress()
//                    UIImpactFeedbackGenerator(style: .medium).impactOccurred() // Haptic feedback
//                }) {
//                    Text("Add")
//                        .font(.title2.bold())
//                        .frame(width: 150, height: 50)
//                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                        .shadow(radius: 10)
//                }
//            }
//            .padding()
                Spacer().frame(height: 20)
            ButtonView(user: user)
                .padding()
            
        }
    }
        .ignoresSafeArea()
    }
}

#Preview {
    AddingView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
