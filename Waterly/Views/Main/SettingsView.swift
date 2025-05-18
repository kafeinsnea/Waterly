import SwiftUI
import UserNotifications

struct SettingsView: View {
    @ObservedObject var user: UserModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isReminderEnabled") private var isReminderEnabled: Bool = false
    @State private var isShowingDeleteConfirmation: Bool = false
    @StateObject var languageManager = LanguageManager()
    @State private var isShowingPrivacyPolicy: Bool = false
    
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
                                await NotificationManager.requestNotificationPermission()
                                await scheduleNotification(startHour: user.wakeup, endHour: user.sleep)
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
                        isShowingPrivacyPolicy = true
                    }
                    Divider()
                    settingsRow(icon: "globe", text: "change_language") {
                        showLanguageSelection()
                    }
                }
                .settingsCard()
                Spacer()
            }
//            .task {
//                await requestNotificationPermission()
//            }
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
            .sheet(isPresented: $isShowingPrivacyPolicy) {
                PrivacyPolicyView()
            }
        }
    }
    
    func scheduleNotification(startHour: Date, endHour: Date,interval: Int = 2) async {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
       
        let calendar = Calendar.current
        guard let wakeHour = calendar.dateComponents([.hour], from: user.wakeup).hour,
              let sleepHour = calendar.dateComponents([.hour], from: user.sleep).hour else {
            print("❌ Saatler alınamadı")
            return
        }

        var hoursToNotify: [Int] = []
        var currentHour = wakeHour
        while currentHour < sleepHour {
            hoursToNotify.append(currentHour)
            currentHour += interval
        }

        for hour in hoursToNotify {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let content = UNMutableNotificationContent()
            content.title = "💧 Time to Drink Water!"
            content.body = "Don't forget to drink a glass of water to stay healthy! 🚰"
            content.sound = .default

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
            .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
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
            .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
            .padding(10)
        Text(LocalizedStringKey(text))
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(.primary)
        Spacer()
        Button(action: action) {
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.6588235294, blue: 0.9098039216, alpha: 1)))
                .padding(8)
        }
    }
    .padding(.horizontal)
}

extension View {
    func settingsCard() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 15).fill(Color("infoCard")))
            .padding([.leading, .trailing])
            .padding(.vertical, 10)
    }
}

#Preview {
    SettingsView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
