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
    @StateObject private var languageManager = LanguageManager()

    init() {
            let context = PersistenceController.shared.container.viewContext
            _user = StateObject(wrappedValue: UserModel(context: context))
        }
    
    var body: some Scene {
        WindowGroup {
            if isRegistered {
                MainView(user: user)
                    .environment(\.managedObjectContext,persistenceController.container.viewContext)
                    .environmentObject(languageManager)
                    .onAppear {
                        Task {
                            await NotificationManager.requestNotificationPermission()
                        }
                    }
            } else {
                HelloView(user:user)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
