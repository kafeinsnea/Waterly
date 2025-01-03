//
//  HomeView.swift
//  WaterTracking
//
//  Created by Sena Çırak on 16.12.2024.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    @State private var yuzde: Int = 0
    @State private var isShowingAlert: Bool = false
    @State private var customAmount: String = ""
    
    var body: some View {
//        NavigationStack{
            VStack(spacing:27) {
                VStack {
                    Text("Daily Target")
                    Text("\(Int(user.dailyGoal)) ml")
                }
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.top,20)
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 235,height: 235)
                        .shadow(color: .blue.opacity(0.5), radius: 25)
                        
                    Circle()
                        .stroke(lineWidth: 20)
                        .foregroundColor(Color.blue.opacity(0.3))
                        .frame(width: 170,height: 170)
                        
                    Circle()
                        .trim(from: 0.0, to: CGFloat(user.progressPercentage) / 100.0)
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [Color.blue, Color.blue]),center: .center),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.5), value: user.progressPercentage)
                        .frame(width: 170,height: 170)
                    
                    VStack {
                        Text("\(user.progressPercentage)%")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .italic()
                            .foregroundStyle(Color.pink)
                        
                        Text("\(Int(user.waterConsumed)) ml Drunk")
                    }
                }
               
                HStack {
                        ButtonView(title: "250 ml") {
                            user.addWater(amount: 250)
                            updateProgress()
                        }
                        ButtonView(title: "500 ml") {
                                user.addWater(amount: 500)
                                updateProgress()
                        }
                }
                Button{
                    isShowingAlert = true
                }label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.white)
                        .background(Circle().foregroundColor(Color.blue).frame(width: 50, height: 50))
                }
                .alert("Enter Custom Amount", isPresented: $isShowingAlert) {
                    TextField("ml", text: $customAmount)
                        .keyboardType(.numberPad)
                    Button("Submit") {
                        if let amount = Double(customAmount) {
                            user.addWater(amount: amount)
                            updateProgress()
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                }
               
                Button( "Reset Progress") {
                    user.resetProgress()
                }
                
                DailyRecordsView(user:user, filterDate: Date())
//                Spacer()
            }
           
//            .navigationTitle("Hello, \(user.username)")
//        }
        
       
        
    }
       
    
    
    
    func updateProgress() {
        let progress = min(user.waterConsumed / user.dailyGoal, 1.0)
        yuzde = Int(progress * 100)
        user.progressPercentage = Int(yuzde)
        user.saveUserData()
    }
    

    
}

#Preview {
    HomeView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
