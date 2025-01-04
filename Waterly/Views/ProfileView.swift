//
//  ProfileView.swift
//  Waterly
//
//  Created by Sena Çırak on 20.12.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var user: UserModel
    @State private var showWakeupPicker: Bool = false
    @State private var showSleepPicker: Bool = false
    @State private var showGoalPicker: Bool = false
    @State private var showGenderPicker: Bool = false
    @State private var showWeightPicker: Bool = false
    @State private var selectedGender = ""
    @State private var selectedWeight: Int 
    init(user: UserModel) {
          self.user = user
          self._selectedWeight = State(initialValue: user.weight) // Başlangıçta user.weight'i al
      }
    let genders = ["Male", "Female"]
    
    var body: some View {
        NavigationStack {
            VStack{
                Image(systemName: "mug")
                    .resizable()
                    .frame(width: 100, height: 100)
                ProfileDetailView(title: "Gender", title2: user.gender){
                    self.showGenderPicker = true
                }
                .confirmationDialog(
                    "Select Gender",
                    isPresented: $showGenderPicker,
                    titleVisibility: .visible
                ) {
                    ForEach(genders, id: \.self) { gender in
                        Button(gender) {
                            user.gender = gender
                            user.saveUserData()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
                
                ProfileDetailView(title: "Weight", title2: "\(user.weight) kg"){
                    showWeightPicker = true
                }
                .sheet(isPresented: $showWeightPicker){
                    VStack {
                        Text("Select Weight")
                            .font(.headline)
                            .padding()
                        Picker("Weight", selection: $selectedWeight) {
                            ForEach(30..<200, id: \.self) { weight in Text("\(weight) kg").tag(weight) }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .padding()
                        Button("Done") {
                            user.weight = selectedWeight
                            user.saveUserData() // Core Data'ya kaydet
                            showWeightPicker = false
                        }
                        .padding()
                    }
                    .presentationDetents([.fraction(0.3)])
                }
                
                ProfileDetailView(title: "Wake-up time", title2: user.gender)
                ProfileDetailView(title: "Sleep time", title2: user.gender)
                ProfileDetailView(title: "Goal", title2: String(user.dailyGoal))
            }
            .padding()
            //            .navigationTitle("Profile Details")
            .toolbar {
                ToolbarItem( placement: .topBarLeading) {
                    Text("Profile Details")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                        .padding(.top,78)
                }
            }
        }
    }
}




#Preview {
    ProfileView(user: UserModel(context: PersistenceController.shared.container.viewContext) )
}
