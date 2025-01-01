//
//  ProfileDetailView.swift
//  WaterTracking2
//
//  Created by Sena Çırak on 30.12.2024.
//

import SwiftUI

struct ProfileDetailView: View {
    var title:String = "vfd"
    var title2 = "gdf"
    var body: some View {
        HStack{
            Image(systemName: "drop")
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
                
            Text(title)
                .font(.system(size: 20, weight:.medium, design: .rounded))
                .foregroundStyle(Color.gray)
            Spacer()
            Button{
                
            }label:{
                Text(title2)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.blue)
            }
        
        }
        .padding()
        Divider()
    }
}

#Preview {
    ProfileDetailView()
}
