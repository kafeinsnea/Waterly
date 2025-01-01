//
//  WaterlyApp.swift
//  Waterly
//
//  Created by Sena Çırak on 16.12.2024.
//

import SwiftUI
import CoreData

@main
struct WaterlyApp: App {
    
    @StateObject private var user: UserModel
    let persistenceController = PersistenceController.shared
    @AppStorage("isRegistered") private var isRegistered: Bool = false
    
    init() {
            let context = PersistenceController.shared.container.viewContext
            _user = StateObject(wrappedValue: UserModel(context: context))
        }
    
    var body: some Scene {
        WindowGroup {
            if isRegistered {
                MainView(user: user)
                    .environment(\.managedObjectContext,persistenceController.container.viewContext)
                     } else {
                         RegistrationView(user:user) 
                             .environment(\.managedObjectContext, persistenceController.container.viewContext)
                     }
        }
    }
}
