//
//  PersistenceController.swift
//  WaterTracking
//
//  Created by Sena Çırak on 17.12.2024.
//

import CoreData

struct PersistenceController {
    static var shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "WaterDataModel")
        container.loadPersistentStores { description, error in
            if let error = error{
                fatalError("Failed to load core data: \(error)")
            }
        }
    }
}
