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
//            RoundedRectangle(cornerRadius: 5)
//                .frame(height: 75)
//                .foregroundColor(Color.white)
//                .shadow(radius: 2)
            HStack{
                ForEach(0..<4){ index in
                    Button{
                        withAnimation {
                            tabSelection = index + 1
                        }
                    } label: {
                        VStack(spacing:8){
                            Spacer()
                            ZStack {
                                if index + 1 == tabSelection{
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 60, height: 60)
                                        .foregroundStyle(Color.blue.opacity(0.5))
                                        .matchedGeometryEffect(id: "selectedTabId", in: animationNamespace)
                                        .offset(y:3)
                                    
                                }else{
                                    Capsule()
                                        .frame(height:8)
                                        .foregroundStyle(Color.clear)
                                        .offset(y:3)
                                }
                                Image(systemName: tabBarItems[index])
                                    .font(.title2)
                                    .foregroundStyle(Color.black)
                            }
                        }
                        .foregroundStyle(index + 1 == tabSelection ? Color.blue : Color.gray)
                        .padding()
                    }
                    
                }
            }
            .frame(height: 75)
//            .clipShape(RoundedRectangle())
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}
