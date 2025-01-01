//
//  MainView.swift
//  Waterly
//
//  Created by Sena Çırak on 20.12.2024.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView{
            HomeView(user: user)
                .tabItem { Image(systemName: "house") }
            GraphicView(user: user)
                .tabItem { Image(systemName: "chart.xyaxis.line") }
            ProfileView(user:user)
                .tabItem { Image(systemName: "person") }
        }
        .onAppear {
            user.loadUserData()
        }
    }
}

#Preview {
    MainView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
