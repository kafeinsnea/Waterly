//
//  NotificationManager.swift
//  Waterly
//
//  Created by Sena Çırak on 18.05.2025.
//

import Foundation
import UserNotifications

struct NotificationManager {
    static func requestNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("✅ Kullanıcı bildirim izni verdi.")
            } else {
                print("🚫 Kullanıcı bildirim iznini reddetti.")
            }
            return granted
        } catch {
            print("❌ Bildirim izni hatası: \(error.localizedDescription)")
            return false
        }
    }
    
    static func scheduleWaterNotifications(wakeUpHour: Int, sleepHour: Int) async {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let interval = 2  // Saat başı veya her 2 saat gibi
        
        for hour in stride(from: wakeUpHour, to: sleepHour, by: interval) {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let content = UNMutableNotificationContent()
            content.title = "💧 Time to Drink Water!"
            content.body = "Don't forget to drink a glass of water to stay healthy! 🚰"
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "water-\(hour)", content: content, trigger: trigger)
            
            try? await center.add(request)
            print("✅ Bildirim \(hour):00 için planlandı.")
        }
    }

    static func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("🚫 Tüm bildirimler iptal edildi.")
    }
}

