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
    @State private var navigateToAddingView = false

    var progress: CGFloat {
        return min(user.waterConsumed / user.dailyGoal, 1.0)
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(spacing:20){
                    NavigationLink(destination: AddingView(user:user)) {
                        ProgressCardView(progress: progress, percentage: user.progressPercentage)
                    }
                                    
                    HStack(spacing: 16){
                        ZStack(alignment: .topLeading)  {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 170)
                                .foregroundStyle(Color.white)
                                .shadow(radius: 10)
                            
                            VStack(alignment: .leading, spacing: 8){
                                Text("🎯 \(Text(LocalizedStringKey("dailygoal")))")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(#colorLiteral(red: 0.41762954, green: 0.3081524226, blue: 0.5259574056, alpha: 1)))
                                    .padding(.bottom,19)

                                HStack {
                                    Text("\(Decimal(user.dailyGoal))")
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                    
                                    Text("mL")
                                        .font(.system(size: 17, weight: .regular, design: .rounded))
                                }
                            }
                            .padding()
                            
                        }
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 170)
                                .foregroundStyle(Color.white)
                                .shadow(radius: 10)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("💧 \(Text(LocalizedStringKey("water")))")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color(#colorLiteral(red: 0.41762954, green: 0.3081524226, blue: 0.5259574056, alpha: 1)))
                                    .padding(.bottom,19)
            
                                HStack {
                                    Text("\(Decimal(user.waterConsumed/1000)) of \(Decimal(user.dailyGoal/1000))")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                    Text("liters")
                                        .font(.system(size: 15, weight: .regular, design: .rounded))
                                }
                                ProgressView(value: progress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue.opacity(0.7)))
                                    .scaleEffect(y: 2)
                                    .padding(.top, 8)
                            }
                            .padding()
                        }
                    }
                    VStack(spacing: -8) {
                        Text("todays_records")
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(#colorLiteral(red: 0.41762954, green: 0.3081524226, blue: 0.5259574056, alpha: 1)))
                            .frame(maxWidth:360, alignment: .leading)
                        
                        DailyRecordsView(user: user, filterDate: Date())
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("\(Text(LocalizedStringKey("hello"))), \(user.username.isEmpty ? "Guest" : user.username) 👋")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(.top,15)
                            .padding()
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
    }
}

struct ProgressCardView: View {
    let progress: CGFloat
    let percentage: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.purple.opacity(0.2))
                .frame(height: 150)
                .shadow(radius: 10)

            HStack {
                CircularProgressView(progress: progress, percentage: percentage)
                    .frame(width: 120, height: 120)
                
                Text("todays_progress")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.purple)
                    .padding()
            }
        }
    }
}

struct CircularProgressView: View {
    let progress: CGFloat
    let percentage: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 11)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color(#colorLiteral(red: 0.41762954, green: 0.3081524226, blue: 0.5259574056, alpha: 1)),style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            Text("\(percentage)%")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .italic()
                .foregroundStyle(Color(#colorLiteral(red: 0.2038662732, green: 0.1776102781, blue: 0.2745614052, alpha: 1)))
        }
    }
}

#Preview {
    HomeView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
