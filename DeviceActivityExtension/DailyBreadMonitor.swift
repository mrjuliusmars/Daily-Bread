//
//  DailyBreadMonitor.swift
//  Daily Bread Device Activity Extension
//

import DeviceActivity
import ManagedSettings
import FamilyControls

class DailyBreadMonitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore(named: .main)
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // When the scheduled interval starts, block the apps
        // Get the saved app tokens
        if let savedData = UserDefaults.standard.data(forKey: "selectedApps"),
           let tokens = try? JSONDecoder().decode(FamilyActivitySelection.self, from: savedData) {
            store.shield.applications = tokens.applicationTokens
            print("✅ Shield applied to \(tokens.applicationTokens.count) apps at scheduled time")
        }
        
        print("🔒 Apps are now blocked - waiting for user to read Bible verse")
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // When the interval ends (or after reading the verse), unblock apps
        store.clearAllSettings()
        
        print("✅ Apps are unblocked")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
    }
}

// Extension to define the activity name
extension DeviceActivityName {
    static let dailyBread = Self("dailyBread")
}

// Extension for ManagedSettingsStore name
extension ManagedSettingsStore.Name {
    static let main = ManagedSettingsStore.Name("main")
}

