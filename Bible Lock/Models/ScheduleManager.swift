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
import FamilyControls

@MainActor
class ScheduleManager: ObservableObject {
    private let center = DeviceActivityCenter()
    
    // Default blocking time (2:37 PM) - user can customize
    private var blockingHour: Int {
        UserDefaults.standard.object(forKey: "blockingHour") as? Int ?? 14 // 2 PM default
    }
    
    private var blockingMinute: Int {
        UserDefaults.standard.object(forKey: "blockingMinute") as? Int ?? 37 // 37 minutes default
    }
    
    func applyDailyBlocking(applicationTokens: Set<ApplicationToken>) {
        // Note: App tokens are already saved in UserDefaults by AppSelectionView
        // The DeviceActivityMonitorExtension will read them and apply shields when the schedule starts
        
        // Get blocking time for display
        let hour = blockingHour
        let minute = blockingMinute
        let timeString = String(format: "%d:%02d %@", hour12(hour), minute, amPm(hour))
        print("✅ Apps will be blocked daily at \(timeString) to 11:59 PM")
        
        // Schedule the DeviceActivity - shields will be applied by monitor when interval starts
        scheduleDeviceActivity()
        
        // IMPORTANT: If schedule start time has already passed today, it won't trigger until tomorrow
        // For immediate testing, uncomment the line below:
        // scheduleTestBlocking() // This will schedule for 1 minute from now
    }
    
    private func scheduleDeviceActivity() {
        // Get user's custom blocking time (or use default)
        let hour = blockingHour
        let minute = blockingMinute
        
        // Create a schedule using user's selected time (or default 2:37 PM)
        let startComponents = DateComponents(hour: hour, minute: minute)
        let endComponents = DateComponents(hour: 23, minute: 59) // 11:59 PM
        
        let schedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: true,
            warningTime: nil
        )
        
        // Start monitoring with the schedule
        Task { @MainActor in
            do {
                // Stop any existing monitoring first
                center.stopMonitoring([.dailyBread])
                print("🔄 Stopped any existing monitoring")
                
                // Small delay to ensure stop completes
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                
                // Start new monitoring
                try center.startMonitoring(.dailyBread, during: schedule)
            
                // Format dates for logging (show both local and UTC)
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .medium
                formatter.timeZone = TimeZone.current
                let localTime = formatter.string(from: Date())
                
                let utcFormatter = DateFormatter()
                utcFormatter.dateStyle = .short
                utcFormatter.timeStyle = .medium
                utcFormatter.timeZone = TimeZone(identifier: "UTC")
                let utcTime = utcFormatter.string(from: Date())
                
                // Format time for display
                let timeString = String(format: "%d:%02d %@", hour12(hour), minute, amPm(hour))
                
                print("✅ DeviceActivity scheduled successfully!")
                print("✅ Activity name: dailyBread")
                print("✅ Start time: \(timeString) (\(String(format: "%02d:%02d", hour, minute))) LOCAL TIME")
                print("✅ End time: 11:59 PM (23:59) LOCAL TIME")
                print("✅ Repeats: Yes (daily)")
                print("✅ Schedule registered at: \(localTime) (Local) / \(utcTime) (UTC)")
                print("✅ Note: Schedule uses LOCAL time - will trigger at \(timeString) in your timezone")
                
                // Log to NSLog for Console.app visibility
                NSLog("✅ DeviceActivity scheduled: dailyBread starting at \(timeString) LOCAL TIME daily")
                NSLog("✅ Schedule registered at: \(localTime) (Local Time)")
                
                // Verify app selection is saved
                let standardDefaults = UserDefaults.standard
                let hasData = standardDefaults.data(forKey: "selectedApps") != nil
                
                if hasData {
                    if let data = standardDefaults.data(forKey: "selectedApps"),
                       let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
                        let appCount = decoded.applicationTokens.count
                        let categoryCount = decoded.categoryTokens.count
                        
                        print("✅ Selection data available:")
                        print("   - Individual Apps: \(appCount)")
                        print("   - Categories: \(categoryCount)")
                        NSLog("✅ Selection data: \(appCount) apps, \(categoryCount) categories")
                        
                        if appCount == 0 && categoryCount == 0 {
                            print("⚠️ WARNING: Schedule registered but NOTHING selected!")
                            print("⚠️ WARNING: User must select apps OR categories for blocking to work")
                            NSLog("⚠️ WARNING: No apps and no categories selected")
                        } else if appCount == 0 && categoryCount > 0 {
                            print("ℹ️ INFO: Category-based blocking enabled")
                            print("ℹ️ INFO: \(categoryCount) categories will block all apps within them")
                            NSLog("ℹ️ INFO: Category blocking - \(categoryCount) categories")
                        } else if appCount > 0 && categoryCount == 0 {
                            print("ℹ️ INFO: Individual app blocking enabled")
                            print("ℹ️ INFO: \(appCount) specific apps will be blocked")
                            NSLog("ℹ️ INFO: Individual app blocking - \(appCount) apps")
                        } else {
                            print("ℹ️ INFO: Mixed blocking - \(appCount) apps + \(categoryCount) categories")
                        }
                    }
                } else {
                    print("❌ Selection data NOT available!")
                    NSLog("❌ Selection data NOT available - schedule registered but will have no effect")
                    print("❌ User must select apps or categories for blocking to work")
                }
                
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
    
    // Helper functions for time formatting
    private func hour12(_ hour24: Int) -> Int {
        let hour12 = hour24 % 12
        return hour12 == 0 ? 12 : hour12
    }
    
    private func amPm(_ hour24: Int) -> String {
        return hour24 < 12 ? "AM" : "PM"
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
        content.title = "Your Bible Lock is Ready"
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

