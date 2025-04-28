import SwiftUI
import UserNotifications

struct SettingsView: View {
    @ObservedObject var user: UserModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isReminderEnabled") private var isReminderEnabled: Bool = false
    @State private var isShowingDeleteConfirmation: Bool = false
    @StateObject var languageManager = LanguageManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    settingsToggle(icon: "moon", text: "dark_mode", toggleBinding: $isDarkMode)
                    Divider()
                    settingsToggle(icon: isReminderEnabled ? "bell.fill" : "bell.slash.fill",
                                   text: "notification",
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
                .padding(.top, 20)

                VStack {
                    settingsRow(icon: "trash", text: "delete_all_data") {
                        isShowingDeleteConfirmation = true
                    }
                    Divider()
                    settingsRow(icon: "shield", text: "privacy_policy") {
                        PrivacyPolicyView()
                    }
                    Divider()
                    settingsRow(icon: "globe", text: "change_language") {
                        showLanguageSelection()
                    }
                }
                .settingsCard()
                Spacer()
            }
            .task {
                await requestNotificationPermission()
            }
            .navigationTitle(Text("settings_title"))
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("settings_title")
//                        .font(.system(size: 28, weight: .bold, design: .rounded))
//                        .foregroundColor(.primary)
//                        .padding(.top, 13)
//                }
//            }
//            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            .alert("delete_confirmation", isPresented: $isShowingDeleteConfirmation) {
                Button("cancel", role: .cancel) {}
                Button("delete", role: .destructive) {
                    user.deleteAllData()
                }
            } message: {
                Text("delete_message")
            }
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

    func showLanguageSelection() {
        let actionSheet = UIAlertController(title: NSLocalizedString("change_language", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "English", style: .default, handler: { _ in
            languageManager.changeLanguage(to: "en")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Türkçe", style: .default, handler: { _ in
            languageManager.changeLanguage(to: "tr")
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel))

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController?.present(actionSheet, animated: true)
        }
    }
}

@ViewBuilder
private func settingsToggle(icon: String, text: String, toggleBinding: Binding<Bool>) -> some View {
    HStack {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .foregroundColor(.accentColor)
            .padding(10)
        Text(LocalizedStringKey(text))
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(.primary)
        Spacer()
        Toggle("", isOn: toggleBinding)
            .toggleStyle(SwitchToggleStyle())
            .accentColor(.blue)
            .padding(5)
    }
    .padding(.horizontal)
}

@ViewBuilder
private func settingsRow(icon: String, text: String, action: @escaping () -> Void) -> some View {
    HStack {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .foregroundColor(.accentColor)
            .padding(10)
        Text(LocalizedStringKey(text))
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(.primary)
        Spacer()
        Button(action: action) {
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.blue)
                .padding(8)
        }
    }
    .padding(.horizontal)
}

extension View {
    func settingsCard() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)).shadow(radius: 5))
            .padding([.leading, .trailing])
            .padding(.vertical, 10)
    }
}

#Preview {
    SettingsView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
