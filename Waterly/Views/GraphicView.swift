//
//  GraphicView.swift
//  Waterly
//
//  Created by Sena Çırak on 19.12.2024.
//

import SwiftUI
import Charts

struct GraphicView: View {
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var user: UserModel
    
    @State private var selectedInterval = "Weekly"
    var intervals = [ "Weekly", "Monthly"]
    
    var body: some View {
        VStack {
            Picker("Interval", selection: $selectedInterval) {
                ForEach(intervals, id: \.self) { interval in
                    Text(interval)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
    

}

#Preview {
    GraphicView(user: UserModel(context: PersistenceController.shared.container.viewContext))
}
