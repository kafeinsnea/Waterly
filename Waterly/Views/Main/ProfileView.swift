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
        NavigationStack{
            VStack {
                HStack{
                    Image(user.gender == "male" ? "male" : "female")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90,height: 90)
                    Text("\(user.username)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                    
                    Button {
                        isEditing.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .frame(width: 24,height: 24)
                    }
                    .sheet(isPresented: $isEditing) {
                        ProfileEditView(user: user)
                    }
                }
                .padding(.horizontal)
                
                
                VStack(spacing:15){
                    ProfileInfoCard(title: "Gender", value: user.gender)
                    ProfileInfoCard(title: "Weight", value: "\(String(user.weight)) kg")
                    ProfileInfoCard(title: "Wake-up time", value: timeFormatter(user.wakeup))
                    ProfileInfoCard(title: "Sleep time", value: timeFormatter(user.sleep))
                    ProfileInfoCard(title: "Goal", value: "\(String(user.dailyGoal)) mL")

                }
                Spacer()
            }
            .padding(.vertical)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Text("Profile")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .padding(.top,20)
                        .padding()
                }
            }
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
            
            HStack{
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                Spacer()
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
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
    @State private var isShowingImagePicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 15) {
                    HStack {
                        Text("Username")
                            .font(.headline)
                        Spacer()
                        TextField("Enter name", text: $user.username)
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
                        Picker("", selection: $user.gender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 180)
                    }

                    HStack {
                        Text("Weight")
                            .font(.headline)
                        Spacer()
                        Stepper("\(user.weight) kg", value: $user.weight, in: 30...200, step: 1)
                    }

                    HStack {
                        Text("Daily Goal")
                            .font(.headline)
                        Spacer()
                        Stepper("\(Int(user.dailyGoal)) mL", value: $user.dailyGoal, in: 500...5000, step: 50)
                    }

                    HStack {
                        Text("Wake-up Time")
                            .font(.headline)
                        Spacer()
                        DatePicker("", selection: $user.wakeup, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }

                    HStack {
                        Text("Sleep Time")
                            .font(.headline)
                        Spacer()
                        DatePicker("", selection: $user.sleep, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                .padding(.horizontal)

                HStack(spacing: 20) {
                    Button(action: {
                        user.loadUserData()
                        dismiss() }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 2))
                    }

                    Button(action: {
                        user.saveUserData()
                        dismiss()
                    }) {
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
}

#Preview {
    ProfileView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
