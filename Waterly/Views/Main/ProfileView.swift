//
//  ProfileView.swift
//  Waterly
//
//  Created by Sena Çırak on 20.12.2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var user: UserModel
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(user.profileImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                    
                    Text(user.username)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color("yazıRengi"))
                        .lineLimit(1) // Overflowu engellemek için
                        .minimumScaleFactor(0.5) // Küçük ekranlarda küçülmesi için
                    
                    Spacer()
                    
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
                    }
                    .sheet(isPresented: $isEditing) {
                        ProfileEditView(user: user)
                    }
                    .padding()
                }
                .padding()
                
                VStack(spacing: 15) {
                    ProfileInfoCard(title: "gender_title", value: user.localizedGender(for: user.gender))
                    ProfileInfoCard(title: "weight_title", value: "\(user.weight) kg")
                    ProfileInfoCard(title: "wakeup_title", value: timeFormatter(user.wakeup))
                    ProfileInfoCard(title: "sleep_title", value: timeFormatter(user.sleep))
                    ProfileInfoCard(title: "goal_title", value: "\(user.dailyGoal) mL")
                    ProfileInfoCard(title: "sport_title", value:user.localizedSportLevel(for: user.sportLevel))
                }
                Spacer()
            }
            .navigationTitle(Text("profile_title"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView(user: user)) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .padding(.top,15)
                            .padding()
                            .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
                    }
                }
            }
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        }
    }
    
    func timeFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}

struct ProfileInfoCard: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(Color("yazıRengi"))
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color("infoCard")))
        .padding(.horizontal)
    }
}

struct ProfileEditView: View {
    @ObservedObject var user: UserModel
    @Environment(\.dismiss) var dismiss
    
    @State private var tempUsername: String
    @State private var tempGender: String
    @State private var tempWeight: Int
    @State private var tempDailyGoal: Double
    @State private var tempWakeup: Date
    @State private var tempSleep: Date
    @State private var tempSportLevel: String
    
    init(user: UserModel) {
        self.user = user
        _tempUsername = State(initialValue: user.username)
        _tempGender = State(initialValue: user.gender)
        _tempWeight = State(initialValue: user.weight)
        _tempDailyGoal = State(initialValue: user.dailyGoal)
        _tempWakeup = State(initialValue: user.wakeup)
        _tempSleep = State(initialValue: user.sleep)
        _tempSportLevel = State(initialValue: user.sportLevel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 15) {
                    HStack {
                        Text("username_title")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Spacer()
                        TextField("Enter name", text: $tempUsername)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 180, height: 10)
                    }
                    
                    HStack {
                        Text("gender_title")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Spacer()
                        Picker("gender_title", selection: $tempGender) {
                            Text(NSLocalizedString("male_title", comment: "")).tag("male")
                            Text("female_title").tag("female")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 180)
                    }
                    
                    HStack {
                        Text("weight_title")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Spacer()
                        Stepper("\(tempWeight) kg", value: $tempWeight, in: 30...200, step: 1)
                    }
                    
                    HStack {
                        Text("goal_title")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Spacer()
                        Stepper("\(Int(tempDailyGoal)) mL", value: $tempDailyGoal, in: 500...5000, step: 50)
                    }
                    
                    HStack {
                        Text("wakeup_title")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Spacer()
                        DatePicker("", selection: $tempWakeup, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("sleep_title")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Spacer()
                        DatePicker("", selection: $tempSleep, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    HStack {
                        Text("sport_title")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                        Spacer()
                        Picker("sport_title", selection: $tempSportLevel) {
                            Text("none_title").tag("none")
                            Text("light_title").tag("light")
                            Text("moderate_title").tag("moderate")
                            Text("intense_title").tag("intense")
                        }
                        .pickerStyle(.menu)
                        .frame(width: 180)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color("infoCard")))
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: { dismiss() }) {
                        Text("cancel")
                            .foregroundStyle(Color("myRed"))
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color("myRed"), lineWidth: 2))
                    }
                    
                    Button(action: saveChanges) {
                        Text("save_title")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top)
            .navigationTitle("edit_profile")
        }
    }
    
    func saveChanges() {
        user.username = tempUsername
        user.gender = tempGender
        user.weight = tempWeight
//        user.dailyGoal = tempDailyGoal
        user.wakeup = tempWakeup
        user.sleep = tempSleep
        user.sportLevel = tempSportLevel
        if user.dailyGoal != tempDailyGoal{
            user.dailyGoal = tempDailyGoal
        }else{
            user.calculateDailyGoal()
        }
        user.saveUserData()
        dismiss()
    }
}

#Preview {
    ProfileView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
