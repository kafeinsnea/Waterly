//
//  CustomTabView.swift
//  Waterly
//
//  Created by Sena Çırak on 11.01.2025.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [String] = [
        ("house"),
        ("drop"),
        ("chart.xyaxis.line"),
        ("person")
    ]
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: 75)
                .foregroundColor(Color.white)
                .shadow(radius: 2)
            HStack{
                ForEach(0..<4){ index in
                    Button{
                        withAnimation {
                            tabSelection = index + 1
                        }
                    } label: {
                        VStack(spacing:8){
                            Spacer()
                            
                            Image(systemName: tabBarItems[index])
                                .font(.title)
                            
                            if index + 1 == tabSelection{
                                Capsule()
                                    .frame(height:8)
                                    .foregroundStyle(Color.blue)
                                    .matchedGeometryEffect(id: "selectedTabId", in: animationNamespace)
                                    .offset(y:3)
                            }else{
                                Capsule()
                                    .frame(height:8)
                                    .foregroundStyle(Color.clear)
                                    .offset(y:3)
                            }
                        }
                        .foregroundStyle(index + 1 == tabSelection ? Color.blue : Color.gray)
                        .padding()
                    }
                    
                }
            }
            .frame(height: 80)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}
