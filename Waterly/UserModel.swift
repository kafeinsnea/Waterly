//
//  UserModel.swift
//  WaterTracking
//
//  Created by Sena Çırak on 18.12.2024.
//

import Foundation
import CoreData

class UserModel: ObservableObject {
    @Published var username: String = ""
    @Published var dailyGoal: Double = 2000.0
    @Published var waterConsumed: Double = 0.0
    @Published var progressPercentage: Int = 0
    @Published var lastUpdated: Date = Date()
    @Published var gender: String = ""
    @Published var weight: Int = 0
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadUserData()
    }
    
    // Core Data'dan kullanıcı verilerini yükler
    func loadUserData() {
        let request: NSFetchRequest<WaterGoal> = WaterGoal.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let userGoal = results.first {
                self.username = userGoal.username ?? ""
                self.dailyGoal = Double(userGoal.dailyGoal)
                self.waterConsumed = Double(userGoal.waterConsumed)
                self.progressPercentage = Int(userGoal.progressPercentage)
                self.lastUpdated = userGoal.lastUpdated ?? Date()
                self.gender = userGoal.gender ?? ""
                self.weight = Int(userGoal.weight)
                checkAndResetForNewDay()
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
    // Su tüketimini kaydeder
    func addWater(amount: Double) {
        waterConsumed += amount
        saveUserData()
        addWaterRecord(amount: amount)
    }
    
    // Kullanıcı verilerini Core Data'ya kaydeder
    func saveUserData() {
        let request: NSFetchRequest<WaterGoal> = WaterGoal.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            let userGoal: WaterGoal
            
            if let existingGoal = results.first {
                userGoal = existingGoal
            } else {
                userGoal = WaterGoal(context: context)
            }
            
            userGoal.username = username
            userGoal.dailyGoal = Int64(dailyGoal)
            userGoal.waterConsumed = Int64(waterConsumed)
            userGoal.progressPercentage = Int64(progressPercentage)
            userGoal.lastUpdated = Date()
            userGoal.gender = gender
            userGoal.weight = Int64(weight)
            
            try context.save()
        } catch {
            print("Error saving user data: \(error)")
        }
    }
    
    
    // WaterRecord kaydı ekler
       func addWaterRecord(amount: Double) {
           let record = WaterRecord(context: context)
           record.amount = amount
           record.date = Date()
           
           do {
               try context.save()
           } catch {
               print("Error saving water record: \(error)")
           }
       }
    
    func checkAndResetForNewDay() {
        let calendar = Calendar.current
        if !calendar.isDateInToday(lastUpdated) {
            resetProgress()
            lastUpdated = Date()
            saveUserData()
        }
    }
    
    func resetProgress() {
        waterConsumed = 0.0
        progressPercentage = 0
        saveUserData()
    }
        
    func fetchRecords(for date: Date) -> [WaterRecord]{
        let request: NSFetchRequest<WaterRecord> = WaterRecord.fetchRequest()
        let calender = Calendar.current
        
        let startOfDay = calender.startOfDay(for: date)
        let endOfDay = calender.startOfDay(for: date.addingTimeInterval(86400))
        
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            return try context.fetch(request)
        }catch {
            print("Error fetching water records: \(error)")
            return []
        }
    }


   }

