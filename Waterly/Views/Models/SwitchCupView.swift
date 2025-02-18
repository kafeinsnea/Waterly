//
//  SwitchCupView.swift
//  Waterly
//
//  Created by Sena Çırak on 17.02.2025.
//

import SwiftUI

struct SwitchCupView: View {
    @ObservedObject var user: UserModel
    @Binding var selectedCupSize: Int?
    @Environment(\.dismiss) var dismiss
    var isDisabled: Bool = false

    let cupSizes: [Int] = [150, 250, 350,500,1000]

    var body: some View {
        VStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                }
                Spacer()
            }
            
            Text("Switch Cup")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.bottom, 10)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                ForEach(cupSizes, id: \.self) { size in
                    Button(action: {
                        selectedCupSize = size
                        user.addWater(amount: Double(size))
                    }) {
                        VStack {
                            getCupIcon(for: size)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                            
                            Text("\(size) mL")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(selectedCupSize == size ? .white : .black)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(selectedCupSize == size ? Color.blue : Color.blue.opacity(0.2)))
                    }
                }
            }
            .padding()

            Button{
                user.saveUserData()
                dismiss()
            }label: {
                Text("OK")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isDisabled ?  Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
            .disabled(isDisabled)
            
         
            
        }
        .padding()
        .onDisappear{
            selectedCupSize = nil
        }
    }

    func getCupIcon(for size: Int) -> Image {
        switch size {
        case 150:
            return Image("150ml")
        case 250:
            return Image("250ml")
        case 350:
            return Image("350ml")
        case 500:
            return Image("500ml")
        case 1000:
            return Image("1lt")
        default:
            return Image(systemName: "drop.fill")
        }
    }
}

#Preview {
    SwitchCupView(user: UserModel(context: PersistenceController.shared.container.viewContext), selectedCupSize: .constant(nil))
}
