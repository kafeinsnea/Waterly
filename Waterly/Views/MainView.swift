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
    @AppStorage("isRegistered") private var isRegistered: Bool = false
    
    var body: some View {
                if isRegistered == true {
                    TabView{
                        HomeView(user: user)
                            .tabItem { Image(systemName: "house") }
                        WaveView(user: user)
                            .tabItem { Image(systemName: "drop") }
                        GraphicView(user: user)
                            .tabItem { Image(systemName: "chart.xyaxis.line") }
                        ProfileView(user:user)
                            .tabItem { Image(systemName: "person") }
                    }
                    .onAppear {
                        user.loadUserData()
                    }
                }else{
                    RegistrationView(user: user)
                }

    }
}

#Preview {
    MainView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
