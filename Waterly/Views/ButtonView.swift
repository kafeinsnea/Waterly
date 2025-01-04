//
//  ButtonView.swift
//  Waterly
//
//  Created by Sena Çırak on 29.12.2024.
//


import SwiftUI

struct ButtonView: View {
    let title: String
    let action: () -> Void // Düğmeye basıldığında çağrılacak closure
    
    var body: some View {
        Button(action: action) {
            HStack{
                Image(systemName: "mug")
                Text(title)
                    .padding()
            }
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(width: 160,height: 60)
        
        
        }
        .background(Color.blue)
        .cornerRadius(10)
        
     
    }
}
