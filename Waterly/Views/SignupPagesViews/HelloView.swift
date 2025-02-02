//
//  HelloView.swift
//  Waterly
//
//  Created by Sena Çırak on 30.01.2025.
//

import SwiftUI

struct HelloView: View {
    var body: some View {
       ZStack {
           VStack {
               Text("Track your daily water consumption, reach your goal and stay healthy!")
                   .padding()
                   .font(.largeTitle)
                   .fontWeight(.bold)
                   .offset(y:-40)
               
               Image("girl")
                   .resizable()
                   .scaledToFit()
                   .clipShape(RoundedRectangle(cornerRadius: 20))
                   .padding()
                   .offset(y:-40)
               
            
               Button{
                   
               }label: {
                   Text("Continue")
                       .font(.title2)
                       .foregroundStyle(Color.white)
                       .background(RoundedRectangle(cornerRadius: 25).fill(Color.black).frame(width: 320,height: 60))
               }
               .offset(y:20)
           }
        }
       .ignoresSafeArea(.all)
        
    }
}

#Preview {
    HelloView()
}
