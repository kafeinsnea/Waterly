//
//  QuestionFlowView.swift
//  Waterly
//
//  Created by Sena Çırak on 31.01.2025.
//

import SwiftUI
import CoreData

enum Gender: String {
    case female, male
}
struct QuestionFlowView: View {
    @ObservedObject var user: UserModel
    @State private var selectedTab: Int = 0
    @AppStorage("isRegistered") private var isRegistered: Bool = false

    var body: some View {
//        if isRegistered {
//            MainView(user: user)
//        }else{
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
                    NameQuestionView(user: user, selectedTab: $selectedTab).tag(0).contentShape(Rectangle()).gesture(DragGesture())
                    GenderQuestionView(selectedTab: $selectedTab, user: user).tag(1).contentShape(Rectangle()).gesture(DragGesture())
                    WeightQuestionView(user: user,selectedTab : $selectedTab).tag(2).contentShape(Rectangle()).gesture(DragGesture())
                    WakeUpQuestionView(selectedTab: $selectedTab, user: user).tag(3).contentShape(Rectangle()).gesture(DragGesture())
                    SleepQuestionView(selectedTab: $selectedTab, user: user).tag(4).contentShape(Rectangle()).gesture(DragGesture())
                    SportQuestionView(user: user, selectedTab: $selectedTab).tag(5).contentShape(Rectangle()).gesture(DragGesture())
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
        }
    }
//}
    
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
            HStack{
//                BackButton(selectedTab: $selectedTab)
                ContinueButton(user: user, selectedTab: $selectedTab, isDisabled: user.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
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
                    user.gender = "Female"
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
                    user.gender = "Male"
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
            HStack{
                BackButton(selectedTab: $selectedTab)
                ContinueButton(user: user, selectedTab: $selectedTab, isDisabled: selectedGender == nil)
            }
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
            HStack{
                BackButton(selectedTab: $selectedTab)
                ContinueButton(user: user, selectedTab: $selectedTab,isDisabled: user.weight == 0)
            }
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
                HStack{
                    BackButton(selectedTab: $selectedTab)
                    ContinueButton(user: user, selectedTab: $selectedTab,isDisabled: user.wakeup == Date.distantPast)
                }
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
                HStack{
                    BackButton(selectedTab: $selectedTab)
                    ContinueButton(user: user, selectedTab: $selectedTab,isDisabled: user.wakeup == Date.distantPast)
                }
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

struct SportQuestionView: View {
    @ObservedObject var user: UserModel
    @Binding var selectedTab: Int
    var isLast: Bool = false
    var body: some View {
        VStack {
            Text("How often do you exercise?")
                .font(.system(size: 43, weight: .bold, design: .rounded))
                .padding(.top, 70)

            VStack(spacing: 20) {
                ForEach(sportLevel.allCases, id: \.self) { level in
                    Button {
                        user.sportLevel = level.rawValue
                    } label: {
                        Text(level.rawValue)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(user.sportLevel == level.rawValue ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
            HStack {
                BackButton(selectedTab: $selectedTab)
                FinishButton(user: user)
            }
           
        }
    }
}
struct FinishButton: View {
    @ObservedObject var user: UserModel
    var isDisabled: Bool = false
    @AppStorage("isRegistered") private var isRegistered: Bool = false
    var body: some View {
        Button{
            user.saveUserData()
            withAnimation(.snappy(duration: 0.4)) {
                isRegistered = true
            }
        }label: {
            Text("Finish")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(RoundedRectangle(cornerRadius: 25).opacity(isDisabled ? 0.5 :  1))
                .padding()
                .shadow(radius: 9)
              
        }
        .disabled(isDisabled)
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
            Text("Continue")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(RoundedRectangle(cornerRadius: 25).opacity(isDisabled ? 0.5 :  1))
                .padding()
                .shadow(radius: 9)
              
        }
        .disabled(isDisabled)
      
    }
}

struct BackButton: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        Button {
            selectedTab -= 1
        } label: {
            Text("<")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
                .frame(width: 90, height: 55)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.black))
                .shadow(radius: 9)
                .padding()
        }
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
