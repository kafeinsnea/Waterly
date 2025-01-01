//
//  ProfileView.swift
//  WaterTracking
//
//  Created by Sena Çırak on 20.12.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var user: UserModel
    
    var body: some View {
        NavigationStack {
            VStack{
                Image(systemName: "mug")
                    .resizable()
                    .frame(width: 100, height: 100)
                ProfileDetailView(title: "Gender", title2: user.gender)
                ProfileDetailView(title: "Weight", title2: String(user.weight))
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
    ProfileView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
