//
//  QuestionFlowView.swift
//  Waterly
//
//  Created by Sena Çırak on 31.01.2025.
//

import SwiftUI

struct QuestionFlowView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            // Üstteki Sekme Gösterimi
            HStack {
                ForEach(0..<4, id: \.self) { index in
                    Rectangle()
                        .fill(index == selectedTab ? Color.white : Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .animation(.easeInOut, value: selectedTab)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            // Seçili View'ı Göster
            TabView(selection: $selectedTab) {
                GenderQuestionView(selectedTab: $selectedTab).tag(0)
                NameQuestionView(selectedTab: $selectedTab).tag(1)
                SportQuestionView(selectedTab: $selectedTab).tag(2)
                WakeUpTimeQuestionView(selectedTab: $selectedTab).tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color.black.ignoresSafeArea())
    }
}

// 📌 1. Cinsiyet Sorusu View
struct GenderQuestionView: View {
    @Binding var selectedTab: Int
    @State private var selectedGender: String? = nil

    var body: some View {
        VStack {
            Text("Gender?")
                .font(.largeTitle).bold().foregroundColor(.white)

            HStack {
                ForEach(["Male", "Female"], id: \.self) { gender in
                    Button(action: { selectedGender = gender }) {
                        Text(gender)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(selectedGender == gender ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                }
            }
            .padding()

            ContinueButton(selectedTab: $selectedTab)
        }
    }
}

// 📌 2. İsim Sorusu View
struct NameQuestionView: View {
    @Binding var selectedTab: Int
    @State private var name: String = ""

    var body: some View {
        VStack {
            Text("What is your name?")
                .font(.largeTitle).bold().foregroundColor(.white)

            TextField("Enter your name...", text: $name)
                .padding()
                .background(Color.white.opacity(0.2))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()

            ContinueButton(selectedTab: $selectedTab)
        }
    }
}

// 📌 3. Spor Seviyesi Sorusu View
struct SportQuestionView: View {
    @Binding var selectedTab: Int
    @State private var selectedSport: String? = nil

    var body: some View {
        VStack {
            Text("How often do you exercise?")
                .font(.largeTitle).bold().foregroundColor(.white)

            ForEach(["Rarely", "Moderate", "Intense"], id: \.self) { level in
                Button(action: { selectedSport = level }) {
                    Text(level)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selectedSport == level ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }

            ContinueButton(selectedTab: $selectedTab)
        }
    }
}

// 📌 4. Uyanma Zamanı Seçme View
struct WakeUpTimeQuestionView: View {
    @Binding var selectedTab: Int
    @State private var wakeUpTime = Date()

    var body: some View {
        VStack {
            Text("What time do you wake up?")
                .font(.largeTitle).bold().foregroundColor(.white)

            DatePicker("Select Time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .foregroundColor(.white)

            ContinueButton(selectedTab: $selectedTab, isLast: true)
        }
    }
}

// 📌 Devam Butonu (Tüm View'larda Kullanılacak)
struct ContinueButton: View {
    @Binding var selectedTab: Int
    var isLast: Bool = false

    var body: some View {
        Button(action: {
            if !isLast { selectedTab += 1 }
        }) {
            Text(isLast ? "Finish" : "Continue")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .padding()
    }
}

// 📌 Önizleme İçin
#Preview {
    QuestionFlowView()
}
