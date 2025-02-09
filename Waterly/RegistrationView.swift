//
//  RegistrationView.swift
//  Waterly
//
//  Created by Sena Çırak on 17.12.2024.
//

import SwiftUI
import CoreData

struct RegistrationView: View {
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    @AppStorage("isRegistered") private var isRegistered: Bool = false
//    @State private var selectedWeight: Int = 0
    
    var body: some View {
        //        if isRegistered == true {
        //            HomeView(user:user)
        //        }else{
        ScrollView{
        ZStack{
            //                Image("background2")
            //                    .resizable()
            //                    .ignoresSafeArea()
            
            VStack{
                Image("waterr")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
                Text("Welcome to Waterly")
                    .font(.system(size: 35, weight: .bold, design: .serif))
                    .italic()
                    .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.2473977804, blue: 0.4044402838, alpha: 1)))
                Spacer().frame(height: 30)
                
                //register
                VStack(alignment:.leading,spacing: 20){
                    Text("Nickname")
                        .font(.system(size: 25, weight:
                                .light, design: .serif))
                        .italic()
                        .foregroundStyle(Color.black.opacity(0.7))
                    
                    
                    TextField("Nickname",text: $user.username)
                        .padding()
                        .frame(width: 250,height: 60)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.8), lineWidth: 1))
                    
                    TextField("gender",text: $user.gender)
                        .padding()
                        .frame(width: 250,height: 60)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.8), lineWidth: 1))
                    Text("Weight")
                        .font(.system(size: 25, weight: .light, design: .serif))
                        .italic()
                        .foregroundStyle(Color.black.opacity(0.7))
                    
                    Picker("Select Weight", selection: $user.weight) {
                        ForEach(30..<200, id: \.self) { weight in
                            Text("\(weight) kg").tag(weight)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 250, height: 100)
                    .clipped()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.8), lineWidth: 1))
                    
                    
                    
                    Text("Daily Goal")
                        .font(.system(size: 25, weight: .light, design: .serif))
                        .italic()
                        .foregroundStyle(Color.black.opacity(0.7))
                    
                    ZStack(alignment:.leading){
                        Slider(value: $user.dailyGoal, in: 500...5000, step: 100)
                            .frame(width: 300)
                            .tint(Color(#colorLiteral(red: 0, green: 0.2473977804, blue: 0.4044402838, alpha: 1)))
                            .shadow(radius: 8)
                        
                        Text("\(Int(user.dailyGoal)) ml")
                            .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.5775004029, blue: 0.7583390474, alpha: 1)))
                            .font(.title3)
                            .offset(x: CGFloat(user.dailyGoal / 5000) * 300 - 20,y:30)
                    }
                    .frame(width: 300)
                    
                    Button(action: {
                        user.saveUserData() // İlgili değişiklikleri kaydetmek için buton ile fonksiyon çağrılır
                    }) {
                        Text("Save")
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(#colorLiteral(red: 0, green: 0.2473977804, blue: 0.4044402838, alpha: 1))))
                            .frame(width: 140, height: 60)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 25, weight: .light, design: .serif))
                            .italic()
                            .shadow(radius: 8)
                    }
                    .padding()
                    
                    DatePicker("wake up time",selection: $user.wakeup, displayedComponents: .hourAndMinute)
                    
                    DatePicker("sleep time",selection: $user.sleep, displayedComponents: .hourAndMinute)
                    
                    Button{
                        user.saveUserData()
                        isRegistered = true
                    }label:{
                        Text("Sign up")
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(#colorLiteral(red: 0, green: 0.2473977804, blue: 0.4044402838, alpha: 1))).frame(width: 140, height: 60))
                            .foregroundStyle(Color.white)
                            .font(.system(size: 25, weight:
                                    .light, design: .serif))
                            .italic()
                            .shadow(radius: 8)
                        
                    }
                    .padding()
                    .offset(x: 89, y: 60)
                    
                }
                .padding()
            }
        }
        .padding(.top, -97)
    }
        
    }
    
//    private func saveUserData(){
//        let userGoal = WaterGoal(context: viewContext)
//        userGoal.username = user.username
//        userGoal.dailyGoal = Int64(user.dailyGoal)
//        do{
//            try viewContext.save()
//            isRegistered = true
//        } catch{
//            print("Error saving user data: \(error)")
//        }
//    }
}

#Preview {
    RegistrationView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
