//
//  HelloView.swift
//  Waterly
//
//  Created by Sena Çırak on 30.01.2025.
//

import SwiftUI
import CoreData

struct HelloView: View {
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    @State private var showQuestions = false
    var body: some View {
        if showQuestions {
            QuestionFlowView(user: user)
        }else{
            ZStack {
                VStack {
                    Text("Track your daily water consumption, reach your goal and stay healthy!")
                        .padding()
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .offset(y:-40)
                    
                    Image("girl3")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                        .offset(y:-40)
                    
                    Button{
                        withAnimation(.snappy(duration: 0.4)) {
                            showQuestions = true
                        }
                       
                    }label: {
                        Text("Continue")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 25))
                            .padding()

                    }
                    .offset(y:20)
                }
            }
            .ignoresSafeArea(.all)
        }
        
    }
}

#Preview {
    HelloView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
