//
//  SettingsView.swift
//  Waterly
//
//  Created by Sena Çırak on 21.02.2025.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @ObservedObject var user: UserModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isReminderEnabled") private var isReminderEnabled: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    settingsToggle(icon: "moon", text: "Dark Mode", toggleBinding: $isDarkMode)
                    Divider()
                    settingsToggle(icon: isReminderEnabled ? "bell.fill" : "bell.slash.fill",
                                   text: "Notifications",
                                   toggleBinding: $isReminderEnabled)
                        .onChange(of: isReminderEnabled) { _, newValue in
                            Task {
                                if newValue {
                                    await requestNotificationPermission()
                                    await scheduleNotification()
                                } else {
                                    cancelNotifications()
                                }
                            }
                        }
                }
                .settingsCard()

                VStack {
                    settingsRow(icon: "trash", text: "Delete all data")
                    Divider()
                    settingsRow(icon: "shield", text: "Privacy policy")
                    Divider()
                    settingsRow(icon: "translate", text: "App Language")
                }
                .settingsCard()
            }
            .task {
                await requestNotificationPermission()
            }
            .navigationTitle("Settings")
        }
    }

    func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            DispatchQueue.main.async {
                if granted {
                    print("✅ Kullanıcı bildirim izni verdi.")
                } else {
                    print("🚫 Kullanıcı bildirim iznini reddetti.")
                }
            }
        } catch {
            print("❌ Bildirim izni hatası: \(error.localizedDescription)")
        }
    }

    func scheduleNotification() async {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let hours = [9, 12, 15, 18, 21]
        for hour in hours {
            let content = UNMutableNotificationContent()
            content.title = "💧 Time to Drink Water!"
            content.body = "Don't forget to drink a glass of water to stay healthy! 🚰"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "water-reminder-\(hour)", content: content, trigger: trigger)

            do {
                try await center.add(request)
                print("✅ Bildirim \(hour):00 için eklendi.")
            } catch {
                print("❌ Bildirim eklenirken hata: \(error.localizedDescription)")
            }
        }
    }

    func cancelNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        print("🚫 Tüm bildirimler iptal edildi!")
    }

    @ViewBuilder
    private func settingsToggle(icon: String, text: String, toggleBinding: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
            Text(text)
                .font(.headline)
            Spacer()
            Toggle("", isOn: toggleBinding)
                .toggleStyle(SwitchToggleStyle())
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func settingsRow(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
            
            Text(text)
                .font(.headline)
            Spacer()
            Button{
                
            }label: {
                Image(systemName: "chevron.right")
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

extension View {
    func settingsCard() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)).shadow(radius: 5))
            .padding()
    }
}

#Preview {
    SettingsView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
