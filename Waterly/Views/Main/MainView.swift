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
    @State private var tabSelection = 1
    var body: some View {
                if isRegistered == true {
                    TabView(selection: $tabSelection){
                        HomeView(user: user)
                            .tag(1)
                        AddingView(user: user)
                            .tag(2)
                        GraphicView2(user: user)
                            .tag(3)
                        ProfileView(user:user)
                            .tag(4)
                    }
                    .overlay(alignment:.bottom){
                        CustomTabView(tabSelection: $tabSelection)
                    }
                    .onAppear {
                        user.loadUserData()
                    }
                }else{
                    HelloView(user: user)
                }

    }
}

#Preview {
    MainView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
