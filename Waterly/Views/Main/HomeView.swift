//
//  HomeView.swift
//  Waterly
//
//  Created by Sena Çırak on 16.12.2024.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @ObservedObject var user: UserModel
    @Environment(\.managedObjectContext) var viewContext
    
    //    @State private var isShowingAlert: Bool = false
    //    @State private var customAmount: String = ""
    
    var progress: CGFloat {
        return min(user.waterConsumed / user.dailyGoal, 1.0) // %100'ü geçmesin
    }
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink(destination: AddingView(user:user)) {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 11)
                        
                        // Dolu Kısım (Progress)
                        Circle()
                            .trim(from: 0.0, to: progress)
                            .stroke(
                                Color(#colorLiteral(red: 0.41762954, green: 0.3081524226, blue: 0.5259574056, alpha: 1)),
                                style: StrokeStyle(lineWidth: 11, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90)) // Yukarıdan başlasın
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        
                        Text("\(user.progressPercentage)%")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .italic()
                            .foregroundStyle(Color(#colorLiteral(red: 0.2038662732, green: 0.1776102781, blue: 0.2745614052, alpha: 1)))
                        
                        
                    }
                    .frame(width: 120, height: 120)
                    .padding()
                    
                    Text("Today's Progress")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(#colorLiteral(red: 0.2038662732, green: 0.1776102781, blue: 0.2745614052, alpha: 1)))
                        .padding()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 370, height: 150)
                        .shadow(radius: 10)
                        .foregroundStyle(Color(#colorLiteral(red: 0.7819901109, green: 0.751116097, blue: 0.8376366496, alpha: 1)))
                )
                
                HStack{
                    ZStack(alignment: .topLeading)  {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 180,height: 150)
                            .foregroundStyle(Color.white)
                            .shadow(radius: 10)
                        
                        VStack{
                            Text("Daily Goal")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .padding()
                        }
                        
                        
                    }
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 180,height: 150)
                            .foregroundStyle(Color.white)
                            .shadow(radius: 10)
                        
                        
                        Text("Water intake")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .padding()
                        
                        VStack {
                            HStack {
                                Text("\(Decimal(user.waterConsumed/1000)) of \(Decimal(user.dailyGoal/1000))")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                Text("Liters")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                            }
                            ProgressView(value: progress)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 10)
                                .padding(.horizontal)
                        }
                        .padding(.top)
                        .offset(x:0, y: 45)
                        
                        
                    }
                    
                }.padding(.horizontal)
                
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Text("Hello, \(user.username) 👋")
                        .font(.system(size: 35, weight: .bold, design: .rounded))
                        .padding(.top,20)
                        .padding()
                }
            }
            
        }
        
    }
}

#Preview {
    HomeView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
