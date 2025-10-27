//
//  DeviceActivityMonitorExtension.swift
//  Daily Bread Monitor
//
//  Created by Marshall Hodge on 10/27/25.
//

import DeviceActivity
import ManagedSettings

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
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

// Extension for ManagedSettingsStore name
extension ManagedSettingsStore.Name {
    static let main = ManagedSettingsStore.Name("main")
}
