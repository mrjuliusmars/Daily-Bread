//
//  StreakTracker.swift
//  Daily Bread
//
//  Tracks consecutive days user puts God first by reading Bible verse
//

import Foundation

class StreakTracker {
    private let lastReadDateKey = "lastVerseReadDate"
    private let currentStreakKey = "currentStreakDays"
    private let longestStreakKey = "longestStreakDays"
    private let totalDaysKey = "totalDaysPuttingGodFirst"
    
    // Mark that user read their verse today
    func markVerseRead() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let defaults = UserDefaults.standard
        
        // Get last read date
        var lastReadDate: Date?
        if let lastReadTimestamp = defaults.object(forKey: lastReadDateKey) as? Date {
            lastReadDate = Calendar.current.startOfDay(for: lastReadTimestamp)
        }
        
        var currentStreak = defaults.integer(forKey: currentStreakKey)
        let totalDays = defaults.integer(forKey: totalDaysKey)
        var longestStreak = defaults.integer(forKey: longestStreakKey)
        
        // Check if already read today
        if let lastDate = lastReadDate, lastDate == today {
            // Already marked today, return current streak
            return currentStreak
        }
        
        // Check if yesterday (continuing streak)
        if let lastDate = lastReadDate {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            let yesterdayStart = Calendar.current.startOfDay(for: yesterday)
            
            if lastDate == yesterdayStart {
                // Continuing streak
                currentStreak += 1
            } else if lastDate < yesterdayStart {
                // Streak broken, start over
                currentStreak = 1
            } else {
                // Same day, no change
                return currentStreak
            }
        } else {
            // First time reading
            currentStreak = 1
        }
        
        // Update longest streak if needed
        if currentStreak > longestStreak {
            longestStreak = currentStreak
            defaults.set(longestStreak, forKey: longestStreakKey)
        }
        
        // Save data
        defaults.set(today, forKey: lastReadDateKey)
        defaults.set(currentStreak, forKey: currentStreakKey)
        defaults.set(totalDays + 1, forKey: totalDaysKey)
        
        return currentStreak
    }
    
    // Get current streak without marking
    func getCurrentStreak() -> Int {
        let defaults = UserDefaults.standard
        let today = Calendar.current.startOfDay(for: Date())
        
        // Check if streak is still valid (read today or yesterday)
        if let lastReadTimestamp = defaults.object(forKey: lastReadDateKey) as? Date {
            let lastReadDate = Calendar.current.startOfDay(for: lastReadTimestamp)
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            let yesterdayStart = Calendar.current.startOfDay(for: yesterday)
            
            // If last read was more than 1 day ago, streak is broken
            if lastReadDate < yesterdayStart {
                return 0
            }
        }
        
        return defaults.integer(forKey: currentStreakKey)
    }
    
    // Get longest streak ever achieved
    func getLongestStreak() -> Int {
        return UserDefaults.standard.integer(forKey: longestStreakKey)
    }
    
    // Get total days (non-consecutive)
    func getTotalDays() -> Int {
        return UserDefaults.standard.integer(forKey: totalDaysKey)
    }
    
    // Check if user has read today
    func hasReadToday() -> Bool {
        guard let lastReadTimestamp = UserDefaults.standard.object(forKey: lastReadDateKey) as? Date else {
            return false
        }
        let today = Calendar.current.startOfDay(for: Date())
        let lastReadDate = Calendar.current.startOfDay(for: lastReadTimestamp)
        return lastReadDate == today
    }
}

