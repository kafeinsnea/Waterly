//
//  QuestionFlowView.swift
//  Waterly
//
//  Created by Sena Çırak on 31.01.2025.
//

import SwiftUI
import CoreData

//struct QuestionFlowView: View {
//    @State private var selectedTab = 0
//    
//    var body: some View {
//        VStack {
//            // Üstteki Sekme Gösterimi
//            HStack {
//                ForEach(0..<4, id: \.self) { index in
//                    Rectangle()
//                        .fill(index == selectedTab ? Color.blue : Color.gray.opacity(0.3))
//                        .frame(height: 4)
//                        .animation(.easeInOut, value: selectedTab)
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .padding(.horizontal)
//
//            // Seçili View'ı Göster
//            TabView(selection: $selectedTab) {
//                GenderQuestionView(selectedTab: $selectedTab).tag(0)
//                NameQuestionView(selectedTab: $selectedTab).tag(1)
//                SportQuestionView(selectedTab: $selectedTab).tag(2)
//                WakeUpTimeQuestionView(selectedTab: $selectedTab).tag(3)
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//        }
////        .background(Color.black.ignoresSafeArea())
//    }
//}
//
//// 📌 1. Cinsiyet Sorusu View
//struct GenderQuestionView: View {
//    @Binding var selectedTab: Int
//    @State private var selectedGender: String? = nil
//
//    var body: some View {
//        VStack {
//            Text("Gender?")
//                .font(.largeTitle).bold()
//
//            HStack {
//                ForEach(["Male", "Female"], id: \.self) { gender in
//                    Button(action: { selectedGender = gender }) {
//                        Text(gender)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(selectedGender == gender ? Color.blue : Color.gray)
//                            .foregroundColor(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 25))
//                    }
//                }
//            }
//            .padding()
//
//            ContinueButton(selectedTab: $selectedTab)
//        }
//    }
//}
//
//// 📌 2. İsim Sorusu View
//struct NameQuestionView: View {
//    @Binding var selectedTab: Int
//    @State private var name: String = ""
//
//    var body: some View {
//        VStack {
//            Text("What is your name?")
//                .font(.largeTitle).bold().foregroundColor(.white)
//
//            TextField("Enter your name...", text: $name)
//                .padding()
//                .background(Color.white.opacity(0.2))
//                .foregroundColor(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .padding()
//
//            ContinueButton(selectedTab: $selectedTab)
//        }
//    }
//}
//
//// 📌 3. Spor Seviyesi Sorusu View
//struct SportQuestionView: View {
//    @Binding var selectedTab: Int
//    @State private var selectedSport: String? = nil
//
//    var body: some View {
//        VStack {
//            Text("How often do you exercise?")
//                .font(.largeTitle).bold().foregroundColor(.white)
//
//            ForEach(["Rarely", "Moderate", "Intense"], id: \.self) { level in
//                Button(action: { selectedSport = level }) {
//                    Text(level)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .background(selectedSport == level ? Color.blue : Color.gray)
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                }
//            }
//
//            ContinueButton(selectedTab: $selectedTab)
//        }
//    }
//}
//
//// 📌 4. Uyanma Zamanı Seçme View
//struct WakeUpTimeQuestionView: View {
//    @Binding var selectedTab: Int
//    @State private var wakeUpTime = Date()
//
//    var body: some View {
//        VStack {
//            Text("What time do you wake up?")
//                .font(.largeTitle).bold().foregroundColor(.white)
//
//            DatePicker("Select Time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
//                .labelsHidden()
//                .datePickerStyle(WheelDatePickerStyle())
//                .foregroundColor(.white)
//
//            ContinueButton(selectedTab: $selectedTab, isLast: true)
//        }
//    }
//}
//
//// 📌 Devam Butonu (Tüm View'larda Kullanılacak)
//struct ContinueButton: View {
//    @Binding var selectedTab: Int
//    var isLast: Bool = false
//
//    var body: some View {
//        Button(action: {
//            if !isLast { selectedTab += 1 }
//        }) {
//            Text(isLast ? "Finish" : "Continue")
//                .frame(maxWidth: .infinity)
//                .frame(height: 50)
//                .background(Color.white)
//                .foregroundColor(.black)
//                .clipShape(RoundedRectangle(cornerRadius: 25))
//        }
//        .padding()
//    }
//}

enum Gender: String {
    case female, male
}
struct QuestionFlowView: View {
    @ObservedObject var user: UserModel
    @State private var selectedTab: Int = 0
    var body: some View {
        VStack{
            HStack{
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(index == selectedTab ? Color.blue : Color.gray.opacity(0.5))
                        .frame(height:4)
                }

                
            }
            .padding(.horizontal)
            
            TabView(selection: $selectedTab) {
                NameQuestionView(user: user, selectedTab: $selectedTab).tag(0)
                GenderQuestionView(selectedTab: $selectedTab, user: user).tag(1)
                WeightQuestionView(user: user,selectedTab : $selectedTab).tag(2)
            }
        }
        .padding()
    }
}

struct NameQuestionView: View {
    @ObservedObject var user: UserModel
    @Binding var selectedTab: Int
    var body: some View {
        VStack {
            Text("Your name?")
                .font(.system(size: 43, weight: .bold, design: .rounded))
            .padding(.top,70)
            Spacer()
            
            TextField("Enter your name...",text: $user.username )
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.blue.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
            Spacer()
            ContinueButton(user: user, selectedTab: $selectedTab, isDisabled: user.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

struct GenderQuestionView: View {
    @Binding var selectedTab: Int
    @ObservedObject var user: UserModel
    @State private var selectedGender: Gender? = nil
    var body: some View {
        VStack{
            Text("Your gender?")
                .font(.system(size: 43, weight: .bold, design: .rounded))
            .padding(.top,70)
            Spacer()
            
            HStack(spacing: 55) {
                Button{
                    selectedGender = .female
                    user.gender = "female"
                }label: {
                    ZStack {
                        Circle()
                            .fill( selectedGender == .female ?  Color.blue : Color.gray)
                            .frame(width: 130, height: 130)
                        Text("♀︎")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                    }
                }
                Button{
                    selectedGender = .male
                    user.gender = "male"
                }label: {
                    ZStack {
                        Circle()
                            .fill(selectedGender == .male ? Color.blue : Color.gray)
                            .frame(width: 130, height: 130)
                        Text("♂︎")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                    }
                }
            }
            Spacer()
            ContinueButton(user: user, selectedTab: $selectedTab, isDisabled: selectedGender == nil)
        }
    }
}

struct WeightQuestionView: View {
    @ObservedObject var user: UserModel
    @Binding var selectedTab: Int
    var body: some View{
        VStack{
            Text("Your weight?")
                .font(.system(size: 43, weight: .bold, design: .rounded))
                .padding(.top,70)
            Text("\(user.weight)kg")
                .font(.system(size: 28, weight: .medium, design: .rounded))
                .foregroundStyle(Color.blue)
                .padding(.top,30)
            Spacer()
            Picker("Select Weight", selection: $user.weight) {
                ForEach(30..<251, id: \.self) { weight in
                    Text("\(weight) kg").tag(weight)
                        .font(.system(size: 23, weight: .medium, design: .rounded))
                        
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 300, height: 170)
          
            Spacer()
            ContinueButton(user: user, selectedTab: $selectedTab,isDisabled: user.weight == 0)
        }
    }
}

struct ContinueButton: View {
    @ObservedObject var user: UserModel
    @Binding var selectedTab: Int
    var isLast: Bool = false
    var isDisabled: Bool = false
    var body: some View {
        Button{
            if !isLast { selectedTab += 1 }
            user.saveUserData()
        }label: {
            Text(isLast ? "Finish" : "Continue")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(RoundedRectangle(cornerRadius: 25).fill(isDisabled ? Color.gray :  Color.black))
                .padding()
                .shadow(radius: 9)
              
        }
        .disabled(isDisabled)
    }
}


#Preview {
    QuestionFlowView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
