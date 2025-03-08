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
                    
                    Text(user.username)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .sheet(isPresented: $isEditing) {
                        ProfileEditView(user: user)
                    }
                    .padding()
                }
                .padding()
                
                VStack(spacing: 15) {
                    ProfileInfoCard(title: "Gender", value: user.gender.capitalized)
                    ProfileInfoCard(title: "Weight", value: "\(user.weight) kg")
                    ProfileInfoCard(title: "Wake-up Time", value: timeFormatter(user.wakeup))
                    ProfileInfoCard(title: "Sleep Time", value: timeFormatter(user.sleep))
                    ProfileInfoCard(title: "Goal", value: "\(user.dailyGoal) mL")
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Profile")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .padding(.top,15)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView(user: user)) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .padding(.top,15)
                            .padding()
                    }
                }
            }
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        }
    }
    
    func timeFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ProfileInfoCard: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 21, weight: .bold, design: .rounded))
            Spacer()
            Text(value)
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .foregroundStyle(Color.blue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)).shadow(radius: 5))
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
    
    init(user: UserModel) {
        self.user = user
        _tempUsername = State(initialValue: user.username)
        _tempGender = State(initialValue: user.gender)
        _tempWeight = State(initialValue: user.weight)
        _tempDailyGoal = State(initialValue: user.dailyGoal)
        _tempWakeup = State(initialValue: user.wakeup)
        _tempSleep = State(initialValue: user.sleep)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 15) {
                    HStack {
                        Text("Username")
                            .font(.headline)
                        Spacer()
                        TextField("Enter name", text: $tempUsername)
                            .multilineTextAlignment(.leading)
                            .frame(width: 150)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    HStack {
                        Text("Gender")
                            .font(.headline)
                        Spacer()
                        Picker("Gender", selection: $tempGender) {
                            Text("Male").tag("male")
                            Text("Female").tag("female")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 180)
                    }
                    
                    HStack {
                        Text("Weight")
                            .font(.headline)
                        Spacer()
                        Stepper("\(tempWeight) kg", value: $tempWeight, in: 30...200, step: 1)
                    }
                    
                    HStack {
                        Text("Daily Goal")
                            .font(.headline)
                        Spacer()
                        Stepper("\(Int(tempDailyGoal)) mL", value: $tempDailyGoal, in: 500...5000, step: 50)
                    }
                    
                    HStack {
                        Text("Wake-up Time")
                            .font(.headline)
                        Spacer()
                        DatePicker("", selection: $tempWakeup, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("Sleep Time")
                            .font(.headline)
                        Spacer()
                        DatePicker("", selection: $tempSleep, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 2))
                    }
                    
                    Button(action: saveChanges) {
                        Text("Save")
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
            .navigationTitle("Edit Profile")
        }
    }
    
    func saveChanges() {
        user.username = tempUsername
        user.gender = tempGender
        user.weight = tempWeight
        user.dailyGoal = tempDailyGoal
        user.wakeup = tempWakeup
        user.sleep = tempSleep
        
        user.saveUserData()
        dismiss()
    }
}

#Preview {
    ProfileView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
