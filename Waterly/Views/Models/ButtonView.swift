//
//  ButtonView.swift
//  Waterly
//
//  Created by Sena Çırak on 29.12.2024.
//


import SwiftUI

struct ButtonView: View {
    let title: String
    let action: (Int) -> Void
    let cupSizes: [Int] = [150, 250, 350, 500, 1000]

    @State private var pressedSize: Int? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(cupSizes, id: \.self) { size in
                    Button(action: {
                        pressedSize  = size
                        action(size)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            pressedSize = nil
                        }
                    }) {
                        VStack {
                            getCupIcon(for: size)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.top,5)

                            Text("\(size) mL")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .frame(width: 100, height: 100)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(radius: 10))
                    }
                    .scaleEffect(pressedSize == size ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 0.3),value: pressedSize)
                   
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
        }
        .frame(height: 140)
    }

    func getCupIcon(for size: Int) -> Image {
        switch size {
        case 150: return Image("150ml")
        case 250: return Image("250ml")
        case 350: return Image("350ml")
        case 500: return Image("500ml")
        case 1000: return Image("1lt")
        default: return Image(systemName: "drop.fill")
        }
    }
}

#Preview {
    ButtonView(title: "250 mL") { size in
        print("Seçilen: \(size) mL")
    }
}
