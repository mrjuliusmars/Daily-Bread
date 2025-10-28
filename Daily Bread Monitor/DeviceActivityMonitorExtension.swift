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
        NSLog("🕐 DeviceActivityMonitorExtension: intervalDidStart called for activity: \(activity)")
        NSLog("🕐 Current time: \(Date())")
        print("🕐 DeviceActivityMonitorExtension: intervalDidStart called for activity: \(activity)")
        print("🕐 Current time: \(Date())")
        
        // When the scheduled interval starts, block the apps
        // Try both App Group and standard UserDefaults
        let appGroupDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread")
        let standardDefaults = UserDefaults.standard
        let userDefaults = appGroupDefaults ?? standardDefaults
        
        NSLog("🔍 Checking UserDefaults: App Group exists: \(appGroupDefaults != nil)")
        
        // Check for saved data in both places
        var savedData: Data? = nil
        if let appGroupData = appGroupDefaults?.data(forKey: "selectedApps") {
            savedData = appGroupData
            NSLog("✅ Found data in App Group UserDefaults")
        } else if let standardData = standardDefaults.data(forKey: "selectedApps") {
            savedData = standardData
            NSLog("✅ Found data in standard UserDefaults")
        }
        
        if let data = savedData {
            NSLog("✅ Found saved app selection data (size: \(data.count) bytes)")
            print("✅ Found saved app selection data")
            
            // Try to decode FamilyActivitySelection
            do {
                let tokens = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
                let appTokens = tokens.applicationTokens
                NSLog("✅ Decoded \(appTokens.count) application tokens")
                print("✅ Decoded \(appTokens.count) application tokens")
                
                // Apply shields - iOS will show the system shield screen
                // Note: iOS doesn't allow full custom shield UI, just the system "Restricted" screen
                store.shield.applications = appTokens
                
                NSLog("✅ Shield applied to \(appTokens.count) apps at scheduled time")
                print("✅ Shield applied to \(appTokens.count) apps at scheduled time")
                print("🔒 Apps are now blocked - waiting for user to read Bible verse")
                
                // Double-check that shields are actually set
                if store.shield.applications?.isEmpty == false {
                    NSLog("✅ Verified: Shields are active with \(appTokens.count) apps")
                } else {
                    NSLog("❌ WARNING: Shields were set but appear to be empty")
                }
            } catch {
                NSLog("❌ Failed to decode FamilyActivitySelection: \(error)")
                print("❌ Failed to decode FamilyActivitySelection: \(error)")
            }
        } else {
            NSLog("❌ No saved app selection data found in UserDefaults")
            NSLog("❌ App Group UserDefaults: \(appGroupDefaults != nil ? "exists" : "does not exist")")
            print("❌ No saved app selection data found in UserDefaults")
            print("❌ This means apps were never selected or data wasn't saved properly")
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
