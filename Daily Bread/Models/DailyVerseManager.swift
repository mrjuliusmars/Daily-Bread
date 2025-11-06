//
//  DailyVerseManager.swift
//  Daily Bread
//
//  Manages daily verse selection and reading status
//

import Foundation
import ManagedSettings

@MainActor
class DailyVerseManager: ObservableObject {
    static let shared = DailyVerseManager()
    
    private let verseDatabase = VerseDatabase.shared
    private let userDefaults = UserDefaults.standard
    private let verseKey = "todaysVerse"
    private let verseDateKey = "verseDate"
    private let hasReadVerseKey = "hasReadVerse"
    private let hasReadDevotionalKey = "hasReadDevotional"
    
    @Published var todaysVerse: BibleVerse?
    @Published var hasReadVerse = false
    @Published var hasReadDevotional = false
    
    private init() {
        loadTodaysVerse()
        checkReadingStatus()
    }
    
    func loadTodaysVerse() {
        // Check if we already have a verse for today
        let today = Calendar.current.startOfDay(for: Date())
        let savedDate = userDefaults.object(forKey: verseDateKey) as? Date
        
        if let savedDate = savedDate,
           Calendar.current.isDate(savedDate, inSameDayAs: today),
           let verseData = userDefaults.data(forKey: verseKey),
           let verse = try? JSONDecoder().decode(BibleVerse.self, from: verseData) {
            todaysVerse = verse
            return
        }
        
        // Generate new verse for today
        let userSettings = UserSettings.shared
        let newVerse = verseDatabase.getTodaysVerse(
            challenges: userSettings.selectedChallenges,
            goals: userSettings.selectedGoals
        )
        
        todaysVerse = newVerse
        
        // Save for today
        if let verseData = try? JSONEncoder().encode(newVerse) {
            userDefaults.set(verseData, forKey: verseKey)
            userDefaults.set(today, forKey: verseDateKey)
            userDefaults.set(false, forKey: hasReadVerseKey)
            userDefaults.set(false, forKey: hasReadDevotionalKey)
        }
    }
    
    func checkReadingStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        let savedDate = userDefaults.object(forKey: verseDateKey) as? Date
        
        // Only check if it's the same day
        if let savedDate = savedDate,
           Calendar.current.isDate(savedDate, inSameDayAs: today) {
            hasReadVerse = userDefaults.bool(forKey: hasReadVerseKey)
            hasReadDevotional = userDefaults.bool(forKey: hasReadDevotionalKey)
        } else {
            // New day, reset
            hasReadVerse = false
            hasReadDevotional = false
        }
    }
    
    func markVerseAsRead() {
        hasReadVerse = true
        userDefaults.set(true, forKey: hasReadVerseKey)
    }
    
    func markDevotionalAsRead() {
        hasReadDevotional = true
        userDefaults.set(true, forKey: hasReadDevotionalKey)
        
        // Unlock apps after devotional is read
        unlockApps()
    }
    
    func hasCompletedDailyReading() -> Bool {
        return hasReadVerse && hasReadDevotional
    }
    
    private func unlockApps() {
        // Clear the ManagedSettingsStore to unlock apps
        let store = ManagedSettingsStore(named: .main)
        store.clearAllSettings()
        
        print("✅ Apps unlocked after completing devotional")
        NSLog("✅ Daily reading completed - apps unlocked")
    }
}

