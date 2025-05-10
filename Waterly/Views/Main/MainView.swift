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
    @State private var selectedTab: Tab = .home
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    enum Tab {
        case home, stats, profile
    }
    
    var body: some View {
        Group{
            if isRegistered {
                NavigationStack {
                    VStack {
                        switch selectedTab {
                        case .home:
                            HomeView(user: user)
                        case .stats:
                            GraphicView(user: user)
                        case .profile:
                            ProfileView(user: user)
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            customTabButton(tab: .home, image: selectedTab == .home ? "house.fill" : "house" , title: "Home").bold()
                            Spacer()
                            customTabButton(tab: .stats, image: selectedTab == .stats ? "chart.bar.fill" : "chart.bar" , title: "Stats")
                            Spacer()
                            customTabButton(tab: .profile, image: selectedTab == .profile ? "person.fill" : "person" , title: "Profile")
                            Spacer()
                        }
                    }
                }
                
            }else {
                HelloView(user: user)
                
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
        private func customTabButton(tab: Tab, image: String, title: String) -> some View {
            Button(action: { selectedTab = tab }) {
                    VStack(spacing: 4) {
                        Image(systemName: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.primary)
                        Text(title)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .opacity(selectedTab == tab ? 1 : 0)
                            .frame(height: 12)
                    }
                    .frame(width: 70)
            }
        }
    
}

#Preview {
    MainView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
