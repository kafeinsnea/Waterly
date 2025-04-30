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
    @State private var tempSelectedCup: Int?

    let cupSizes: [Int] = [150, 250, 350,500,1000]

    var body: some View {
        GeometryReader{ geometry in
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .bold()
                            .padding()
                    }
                    Spacer()
                }
                
                Text("Add")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                    ForEach(cupSizes, id: \.self) { size in
                        Button(action: {
                            tempSelectedCup = size
                        }) {
                            HStack {
                                getCupIcon(for: size)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                
                                Text("\(size) mL")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .frame(width: geometry.size.width/3.5, height: geometry.size.width/5.5)
                            .background(RoundedRectangle(cornerRadius: 15).fill(tempSelectedCup == size ? Color("cupColor") : Color("cupColor2")))
                        }
                    }
                }
                .padding(.vertical)
                .frame(height:geometry.size.height*0.5)
                
                Button{
                    if let selectedSize = tempSelectedCup{
                        selectedCupSize = selectedSize
                        user.addWater(amount: Double(selectedSize))
                        user.saveUserData()
                    }
                    dismiss()
                }label: {
                    Text("OK")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background((tempSelectedCup == nil || isDisabled) ?  Color.gray.opacity(0.5) : Color("myRed"))
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                }
                .disabled(tempSelectedCup == nil || isDisabled)
            }
            .padding()
            .onDisappear{
                selectedCupSize = nil
            }
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
