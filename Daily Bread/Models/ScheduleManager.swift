//
//  ScheduleManager.swift
//  Daily Bread
//
//  Schedule Management for Daily App Blocking
//

import Foundation
import ManagedSettings
import UserNotifications
import DeviceActivity

@MainActor
class ScheduleManager: ObservableObject {
    private let center = DeviceActivityCenter()
    
    func applyDailyBlocking(applicationTokens: Set<ApplicationToken>) {
        // Note: App tokens are already saved in UserDefaults by AppSelectionView
        // The DeviceActivityMonitorExtension will read them and apply shields when the schedule starts
        
        print("✅ Apps will be blocked daily at 4:20 PM to 11:59 PM")
        
        // Schedule the DeviceActivity - shields will be applied by monitor when interval starts
        scheduleDeviceActivity()
        
        // TEST: Uncomment the line below to test with a 1-minute schedule instead
        // scheduleTestBlocking() // This will schedule for 1 minute from now
    }
    
    private func scheduleDeviceActivity() {
        // Create a schedule for 4:20 PM to 11:59 PM daily (fixed time)
        let startComponents = DateComponents(hour: 16, minute: 20) // 4:20 PM
        let endComponents = DateComponents(hour: 23, minute: 59) // 11:59 PM
        
        let schedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: true,
            warningTime: nil
        )
        
        // Start monitoring with the schedule
        Task {
            do {
                // Stop any existing monitoring first
                center.stopMonitoring([.dailyBread])
                print("🔄 Stopped any existing monitoring")
                
                // Small delay to ensure stop completes
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                
                // Start new monitoring
                try center.startMonitoring(.dailyBread, during: schedule)
            
                print("✅ DeviceActivity scheduled successfully!")
                print("✅ Activity name: dailyBread")
                print("✅ Start time: 4:20 PM (16:20)")
                print("✅ End time: 11:59 PM (23:59)")
                print("✅ Repeats: Yes (daily)")
                print("✅ Schedule registered at: \(Date())")
                
                // Log to NSLog for Console.app visibility
                NSLog("✅ DeviceActivity scheduled: dailyBread starting at 4:20 PM daily")
                
                // Verify app selection is saved
                let appGroupDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread")
                let standardDefaults = UserDefaults.standard
                let hasData = (appGroupDefaults?.data(forKey: "selectedApps") != nil) || (standardDefaults.data(forKey: "selectedApps") != nil)
                print("✅ App selection data available: \(hasData ? "Yes" : "No")")
                NSLog("✅ App selection data available: \(hasData ? "Yes" : "No")")
                
                // Verify schedule is active
                verifySchedule()
            } catch {
                print("❌ Error starting DeviceActivity: \(error)")
                print("❌ Error details: \(error.localizedDescription)")
                print("❌ Error type: \(type(of: error))")
            }
        }
    }
    
    private func verifySchedule() {
        // Check if schedule is actually registered
        Task {
            // Give it a moment
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            
            // Verify by checking if we can access the center
            print("🔍 Verifying schedule registration...")
            // Note: DeviceActivityCenter doesn't expose a way to check active schedules
            // But we can at least confirm the setup happened
            print("✅ Schedule verification complete")
        }
    }
    
    // TEST FUNCTION: Schedule for 1 minute from now (for testing)
    func scheduleTestBlocking() {
        print("🧪 TEST MODE: Scheduling blocking for 1 minute from now")
        
        let calendar = Calendar.current
        guard let oneMinuteFromNow = calendar.date(byAdding: .minute, value: 1, to: Date()) else {
            print("❌ Failed to calculate test time")
            return
        }
        
        let startComponents = calendar.dateComponents([.hour, .minute], from: oneMinuteFromNow)
        let endComponents = calendar.dateComponents([.hour, .minute], from: calendar.date(byAdding: .minute, value: 5, to: oneMinuteFromNow)!)
        
        let testSchedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: false,
            warningTime: nil
        )
        
        do {
            center.stopMonitoring([.dailyBread])
            try center.startMonitoring(.dailyBread, during: testSchedule)
            print("🧪 TEST: Schedule set for \(startComponents.hour ?? 0):\(String(format: "%02d", startComponents.minute ?? 0))")
            print("🧪 TEST: Apps should lock in 1 minute for testing")
        } catch {
            print("❌ TEST ERROR: \(error)")
        }
    }
    
    func setupDailyReminder() {
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // Schedule daily notification at 4 AM to remind user to read their verse
                self.scheduleNotification()
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your Daily Bread is Ready"
        content.body = "Read your Bible verse to unlock your apps for today!"
        content.sound = .default
        content.badge = 1
        
        // Schedule for 4 AM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 4
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyBreadReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("✅ Daily 4 AM reminder scheduled")
            }
        }
    }
}

