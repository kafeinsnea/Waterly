//
//  QuestionFlowView.swift
//  Waterly
//
//  Created by Sena Çırak on 31.01.2025.
//

import SwiftUI
import CoreData


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

enum Gender: String {
    case female, male
}
struct QuestionFlowView: View {
    @ObservedObject var user: UserModel
    @State private var selectedTab: Int = 0
    var body: some View {
        VStack{
            HStack{
                ForEach(0..<6, id: \.self) { index in
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
                WakeUpQuestionView(selectedTab: $selectedTab, user: user).tag(3)
                SleepQuestionView(selectedTab: $selectedTab, user: user).tag(4)
            }
            .edgesIgnoringSafeArea(.all)
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
            .clipped()
           
          
            Spacer()
            ContinueButton(user: user, selectedTab: $selectedTab,isDisabled: user.weight == 0)
        }
    }
}

struct WakeUpQuestionView: View {
    @Binding var selectedTab: Int
    @ObservedObject var user: UserModel

    @State private var selectedHour: Int = Calendar.current.component(.hour, from: Date())
    @State private var selectedMin: Int = Calendar.current.component(.minute, from: Date())
    var body: some View {
            VStack {
                Text("Wake up time?")
                    .font(.system(size: 43, weight: .bold, design: .rounded))
                    .padding(.top, 70)
                
                Text("\(formattedTime(user.wakeup))")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.blue)
                    .padding(.top,30)
                Spacer()
                HStack {
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text("\(hour)").tag(hour)
                                .font(.system(size: 23, weight: .medium, design: .rounded))
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 170)
                    .clipped()
                    .onChange(of: selectedHour) { updateWakeUpTime() }
                    
                    Text(":")
                    .font(.system(size: 30, weight: .bold))
                    
                    Picker("Minute", selection: $selectedMin) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                                .font(.system(size: 23, weight: .medium,
                                              design: .rounded))
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 170)
                    .clipped()
                    .onChange(of: selectedMin) { updateWakeUpTime() }
                }
                
                Spacer()
                ContinueButton(user: user, selectedTab: $selectedTab,isDisabled: user.wakeup == Date.distantPast)
            }
    }
    private func updateWakeUpTime() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: user.wakeup)
        components.hour = selectedHour
        components.minute = selectedMin

        if let newDate = calendar.date(from: components) {
            user.wakeup = newDate
        }
    }
  
}

struct SleepQuestionView: View {
    @Binding var selectedTab: Int
    @ObservedObject var user: UserModel

    @State private var selectedHour: Int = Calendar.current.component(.hour, from: Date())
    @State private var selectedMin: Int = Calendar.current.component(.minute, from: Date())
    var body: some View {
            VStack {
                Text("Sleep time?")
                    .font(.system(size: 43, weight: .bold, design: .rounded))
                    .padding(.top, 70)
                
                Text("\(formattedTime(user.sleep))")
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.blue)
                    .padding(.top,30)
                Spacer()
                HStack {
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text("\(hour)").tag(hour)
                                .font(.system(size: 23, weight: .medium, design: .rounded))
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 170)
                    .clipped()
                    .onChange(of: selectedHour) { updateSleepTime() }
                    
                    Text(":")
                    .font(.system(size: 30, weight: .bold))
                    
                    Picker("Minute", selection: $selectedMin) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute)).tag(minute)
                                .font(.system(size: 23, weight: .medium,
                                              design: .rounded))
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 170)
                    .clipped()
                    .onChange(of: selectedMin) { updateSleepTime() }
                }
                
                Spacer()
                ContinueButton(user: user, selectedTab: $selectedTab,isDisabled: user.wakeup == Date.distantPast)
            }
    }
    private func updateSleepTime() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: user.sleep)
        components.hour = selectedHour
        components.minute = selectedMin

        if let newDate = calendar.date(from: components) {
            user.sleep = newDate
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


 func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

#Preview {
    QuestionFlowView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
