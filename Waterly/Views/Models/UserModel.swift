//
//  UserModel.swift
//  Waterly
//
//  Created by Sena Çırak on 18.12.2024.
//

import Foundation
import CoreData

enum sportLevel: String, CaseIterable {
    case none = "none"
    case light = "light"
    case moderate = "moderate"
    case intense = "intense"
}
class UserModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var dailyGoal: Double = 2000.0
    @Published var waterConsumed: Double = 0.0
    @Published var progressPercentage: Int = 0
    @Published var lastUpdated: Date = Date()
    @Published var gender: String = "female" {
        didSet {
            updateProfileImage()
            print("Gender changed to: \(gender)")
        }
    }
    @Published var profileImage: String = "female"
    @Published var weight: Int = 0
    @Published var wakeup: Date = Date()
    @Published var sleep: Date = Date()
    @Published var sportLevel: String = ""
    
    private func updateProfileImage() {
        profileImage = (gender == "female") ? "female" : "male"
    }
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadUserData()
        
        if dailyGoal == 2000{
            calculateDailyGoal()
        }
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
                self.sportLevel = userGoal.sportLevel ?? ""
                // 🌍 UTC'yi yerel saate çevirerek al
                self.wakeup = convertToLocal(date: userGoal.wakeup ?? Date())
                self.sleep = convertToLocal(date: userGoal.sleep ?? Date())
                
                checkAndResetForNewDay()
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
    // 📌 Tarihi yerel saate çeviren fonksiyon
    func convertToLocal(date: Date) -> Date {
        let timezoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        return date.addingTimeInterval(timezoneOffset)
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
            userGoal.sportLevel = sportLevel
            
            // 🌍 Yerel zamanı UTC'ye çevirerek kaydet
            userGoal.wakeup = convertToUTC(date: wakeup)
            userGoal.sleep = convertToUTC(date: sleep)
            
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error saving user data: \(error)")
        }
    }
    
    // 📌 Tarihi UTC'ye çeviren fonksiyon
    func convertToUTC(date: Date) -> Date {
        let timezoneOffset = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        return date.addingTimeInterval(-timezoneOffset)
    }
    
    
    
    
    // Su tüketimini kaydeder
    func addWater(amount: Double) {
        waterConsumed += amount
        saveUserData()
        addWaterRecord(amount: amount)
        updateProgress()
    }
    
    func removeLastAddedWater() {
        let records = fetchRecords(for: Date())
        
        guard let lastRecord = records.last else { return }
        deleteRecord(lastRecord)
        updateProgress()
    }
    
    func deleteRecord(_ record: WaterRecord){
        guard let context = record.managedObjectContext else { return }
        waterConsumed -= record.amount
        context.delete(record)
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Error deleting record: \(error)")
        }
    }
    // WaterRecord kaydı ekler
    func addWaterRecord(amount: Double) {
        let record = WaterRecord(context: context)
        record.amount = amount
        record.date = Date()
        
        do {
            if context.hasChanges {
                try context.save()
            }
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
    
    func updateProgress() {
        let progress = min(waterConsumed / dailyGoal, 1.0)
        progressPercentage = Int(progress * 100)
        saveUserData()
    }
    
    func resetProgress() {
        waterConsumed = 0.0
        progressPercentage = 0
        saveUserData()
    }
    
    func fetchRecords(for date: Date) -> [WaterRecord]{
        let request: NSFetchRequest<WaterRecord> = WaterRecord.fetchRequest()
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            return try context.fetch(request)
        }catch {
            print("Error fetching water records: \(error)")
            return []
        }
    }
    // Haftalık değil, yıllık veri çekmek için fonksiyonu değiştirelim
    func fetchRecordsForYear(year: Int) -> [WaterRecord] {
        let request: NSFetchRequest<WaterRecord> = WaterRecord.fetchRequest()
        let calendar = Calendar.current
        
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!
        
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startOfYear as NSDate, endOfYear as NSDate)
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching water records for year \(year): \(error)")
            return []
        }
    }
    
    func deleteAllData() {
        let fetchRequests: [NSFetchRequest<NSFetchRequestResult>] = [
            WaterGoal.fetchRequest(),
            WaterRecord.fetchRequest()
        ]
        
        do {
            for request in fetchRequests {
                let objects = try context.fetch(request)
                for object in objects {
                    if let object = object as? NSManagedObject {
                        context.delete(object)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.resetUserDefaults()
            }
            print("✅ All user data deleted successfully.")
        } catch {
            print("❌ Error deleting all data: \(error)")
        }
    }
    
    private func resetUserDefaults() {
        username = ""
        dailyGoal = 2000.0
        waterConsumed = 0.0
        progressPercentage = 0
        gender = "female"
        profileImage = "female"
        weight = 0
        wakeup = Date()
        sleep = Date()
        sportLevel = "none"
    }
    func fetchAllRecords() -> [WaterRecord] {
        let request: NSFetchRequest<WaterRecord> = WaterRecord.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching all water records: \(error)")
            return []
        }
    }
    
    var bestDayAmount: Double {
        let records = fetchAllRecords()
        var dailyWaterConsumption: [String: Double] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        for record in records {
            let dateString = dateFormatter.string(from: record.date ?? Date())
            dailyWaterConsumption[dateString, default: 0.0] += record.amount
        }
        guard let bestDay = dailyWaterConsumption.max(by: { $0.value < $1.value }) else {
            return 0.0
        }
        return bestDay.value
    }
    var bestDayAmountDate: String {
        let records = fetchAllRecords()
        var dailyWaterConsumption: [String: Double] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        for record in records {
            let dateString = dateFormatter.string(from: record.date ?? Date())
            dailyWaterConsumption[dateString, default: 0.0] += record.amount
        }
        guard let bestDay = dailyWaterConsumption.max(by: { $0.value < $1.value }) else {
            return ""
        }
        return bestDay.key
    }
    func calculateDailyGoal() {
        let baseMultiplier: Double
        
        if gender == "female"{
            baseMultiplier = 30
        }else{
            baseMultiplier = 35
        }
        
        var newDailyGoal = Double(weight) * baseMultiplier
        
        switch sportLevel {
        case "none":
            newDailyGoal += 0
        case "low":
            newDailyGoal += 300
        case "moderate":
            newDailyGoal += 500
        case "intense":
            newDailyGoal += 1000
        default:
            break
        }
        
        dailyGoal = max(1500, min(newDailyGoal,4000))
        
    }
    func localizedGender(for gender: String) -> String {
        switch gender {
        case "male":
            return NSLocalizedString("male_title", comment: "")
        case "female":
            return NSLocalizedString("female_title", comment: "")
        default:
            return ""
        }
    }
    func localizedSportLevel(for level: String) -> String {
        switch level {
        case "none":
            return NSLocalizedString("none_title", comment: "")
        case "light":
            return NSLocalizedString("light_title", comment: "")
        case "moderate":
            return NSLocalizedString("moderate_title", comment: "")
        case "intense":
            return NSLocalizedString("intense_title", comment: "")
        default:
            return NSLocalizedString("none_title", comment: "")
        }
    }
}
