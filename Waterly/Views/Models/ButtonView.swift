//
//  ButtonView.swift
//  Waterly
//
//  Created by Sena Çırak on 29.12.2024.
//


import SwiftUI

struct ButtonView: View {
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    
    let cupSizes: [Int] = [150, 250, 350, 500, 1000]

    @State private var pressedSize: Int? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 20) {
                ForEach(cupSizes, id: \.self) { size in
                    Button {
                        pressedSize  = size
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            pressedSize = nil
                        }
                        user.addWater(amount: Double(size))
                        user.saveUserData()
                        user.updateProgress()
                    } label:{
                        VStack {
                            getCupIcon(for: size)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .padding(.top,5)
                            
                            Text("\(size) mL")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .frame(width: 85, height: 85)
                        .background(RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.5).gradient)
                            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3))
                    }
                    .scaleEffect(pressedSize == size ? 0.92 : 1.0)
                    .animation(.easeInOut(duration: 0.2),value: pressedSize)
                   
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
        }
        .frame(height: 120)
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
    ButtonView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
