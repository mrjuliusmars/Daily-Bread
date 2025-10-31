//
//  DeviceActivityMonitorExtension.swift
//  Daily Bread Monitor
//
//  Created by Marshall Hodge on 10/27/25.
//

import DeviceActivity
import ManagedSettings
import FamilyControls
import Foundation
import UIKit

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore(named: .main)
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // CRITICAL: Log to both NSLog (shows in Console.app) and print
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        let localTime = formatter.string(from: Date())
        
        NSLog("🕐 DeviceActivityMonitorExtension: intervalDidStart called for activity: \(activity)")
        NSLog("🕐 Current LOCAL time: \(localTime)")
        print("🕐 DeviceActivityMonitorExtension: intervalDidStart called for activity: \(activity)")
        print("🕐 Current LOCAL time: \(localTime)")
        
        // When the scheduled interval starts, block the apps
        // Use standard UserDefaults (more reliable than App Groups for extensions)
        let standardDefaults = UserDefaults.standard
        
        NSLog("🔍 Checking standard UserDefaults for saved app selection")
        
        // Check for saved data
        var savedData: Data? = standardDefaults.data(forKey: "selectedApps")
        
        // Fallback to App Group if available (but don't rely on it)
        if savedData == nil {
            if let appGroupDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread"),
               let appGroupData = appGroupDefaults.data(forKey: "selectedApps") {
                savedData = appGroupData
                NSLog("✅ Found data in App Group UserDefaults (fallback)")
            }
        } else {
            NSLog("✅ Found data in standard UserDefaults")
        }
        
        if let data = savedData {
            NSLog("✅ Found saved app selection data (size: \(data.count) bytes)")
            print("✅ Found saved app selection data")
            
            // Try to decode FamilyActivitySelection
            do {
                let tokens = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
                let appTokens = tokens.applicationTokens
                let categoryTokens = tokens.categoryTokens
                
                NSLog("✅ Decoded selection - Apps: \(appTokens.count), Categories: \(categoryTokens.count)")
                print("✅ Decoded selection - Apps: \(appTokens.count), Categories: \(categoryTokens.count)")
                
                // Apply shields for individual apps
                if !appTokens.isEmpty {
                    store.shield.applications = appTokens
                    NSLog("✅ Shield applied to \(appTokens.count) individual apps")
                    print("✅ Shield applied to \(appTokens.count) individual apps")
                }
                
                // IMPORTANT: Apply shields for categories (blocks all apps in category)
                if !categoryTokens.isEmpty {
                    store.shield.applicationCategories = .specific(categoryTokens)
                    NSLog("✅ Shield applied to \(categoryTokens.count) categories (blocks all apps in those categories)")
                    print("✅ Shield applied to \(categoryTokens.count) categories")
                    print("   Note: All apps within selected categories will be blocked")
                }
                
                // Verify shields are set
                let totalBlocking = appTokens.count + categoryTokens.count
                if totalBlocking > 0 {
                    NSLog("✅ Verified: Shields are active - \(appTokens.count) apps + \(categoryTokens.count) categories")
                    print("🔒 Apps are now blocked - waiting for user to read Bible verse")
                    
                    if appTokens.isEmpty && !categoryTokens.isEmpty {
                        print("ℹ️ Using category-based blocking (no individual apps)")
                    }
                } else {
                    NSLog("❌ WARNING: Both app and category tokens are empty - shields not applied")
                    print("❌ WARNING: No blocking applied - selection was empty")
                }
            } catch {
                NSLog("❌ Failed to decode FamilyActivitySelection: \(error)")
                print("❌ Failed to decode FamilyActivitySelection: \(error)")
            }
        } else {
            NSLog("❌ No saved app selection data found in UserDefaults")
            NSLog("❌ Current time: \(Date())")
            NSLog("❌ Activity: \(activity)")
            print("❌ No saved app selection data found in UserDefaults")
            print("❌ This means apps were never selected or data wasn't saved properly")
            print("❌ Schedule will NOT block any apps - user needs to select apps first")
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        print("🕐 DeviceActivityMonitorExtension: intervalDidEnd called for activity: \(activity)")
        print("🕐 Current time: \(Date())")
        
        // When the interval ends, unblock apps
        store.clearAllSettings()
        
        print("✅ Apps are unblocked")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        print("🕐 DeviceActivityMonitorExtension: eventDidReachThreshold called")
    }
}

// Extension for ManagedSettingsStore name
extension ManagedSettingsStore.Name {
    static let main = ManagedSettingsStore.Name("main")
}

// Extension for DeviceActivityName - must match the name used in ScheduleManager
extension DeviceActivityName {
    static let dailyBread = DeviceActivityName("dailyBread")
}
