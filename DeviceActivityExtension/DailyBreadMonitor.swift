//
//  DailyBreadMonitor.swift
//  Daily Bread Device Activity Extension
//

import DeviceActivity
import ManagedSettings

class DailyBreadMonitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore(named: .main)
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("📱 Device activity started")
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("✅ Device activity ended")
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

