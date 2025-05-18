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
                                      let granted = await NotificationManager.requestNotificationPermission()
                                      if granted {
                                          let wakeUpHour = Calendar.current.component(.hour, from: user.wakeup)
                                          let sleepHour = Calendar.current.component(.hour, from: user.sleep)
                                          await NotificationManager.scheduleWaterNotifications(wakeUpHour: wakeUpHour, sleepHour: sleepHour)
                                      } else {
                                          isReminderEnabled = false
                                      }
                            } else {
                                NotificationManager.cancelAllNotifications()
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
            .task {
                let settings = await UNUserNotificationCenter.current().notificationSettings()
                if settings.authorizationStatus != .authorized {
                    isReminderEnabled = false
                }
            }
//            .task {
//                await requestNotificationPermission()
//            }
            .navigationTitle(Text("settings_title"))
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
