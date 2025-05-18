//
//  NotificationManager.swift
//  Waterly
//
//  Created by Sena Çırak on 18.05.2025.
//

import Foundation
import UserNotifications

struct NotificationManager {
    static  func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            DispatchQueue.main.async {
                if granted {
                    print("✅ Kullanıcı bildirim izni verdi.")
                    UserDefaults.standard.set(true, forKey: "isReminderEnabled")
                } else {
                    print("🚫 Kullanıcı bildirim iznini reddetti.")
                    UserDefaults.standard.set(false, forKey: "isReminderEnabled")
                }
            }
        } catch {
            print("❌ Bildirim izni hatası: \(error.localizedDescription)")
        }
    }

}
