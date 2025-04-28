//
//  HydrationView.swift
//  Waterly
//
//  Created by Sena Çırak on 13.02.2025.
//

import SwiftUI

struct HydrationView: View {
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    @State private var isSheetPresented = false
    @State private var lastAddedAmount: Double = 0
    @State private var showAlert = false
    @State private var selectedAmount: Double = 250
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.2))
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                        .frame(height: 500)
                        .padding()
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
                        
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                isSheetPresented = true
                            }) {
                                Text("💧")
                                    .font(.title2.bold())
                                    .frame(width: 55, height: 55)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .sheet(isPresented: $isSheetPresented) {
                                CustomAmountSheet(isPresented: $isSheetPresented, user: user)
                            }
                            
                            Button {
                                showAlert = true
                            } label: {
                                Text("-")
                                    .font(.title)
                                    .frame(width: 55, height: 55)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                            .alert("Remove last added water?", isPresented: $showAlert) {
                                Button("Cancel", role: .cancel) {}
                                Button("Remove", role: .destructive) {
                                    user.removeLastAddedWater()
                                }
                            }
                            
                            Button {
                                user.addWater(amount: 250)
                                user.saveUserData()
                                user.updateProgress()
                            } label: {
                                Text("Drink (250 mL)")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top,40)
                                                               
                    }
                }
                .navigationTitle(Text("hydration"))
            }
            Spacer().frame(height: 100)
            
        }.ignoresSafeArea()
    }
        
}
struct CustomAmountSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var user: UserModel
    @State private var customAmount: String = ""

    var body: some View {
        VStack {
            Text("enter_amount")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding()

            TextField("mL", text: $customAmount)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("cancel") {
                    isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button("add") {
                    if let amount = Double(customAmount), amount > 0 {
                        user.addWater(amount: amount)
                        user.saveUserData()
                        user.updateProgress()
                        isPresented = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
        }
        .frame(maxHeight: 250)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
        .presentationDetents([.height(250)])
    }
}

#Preview {
    HydrationView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
