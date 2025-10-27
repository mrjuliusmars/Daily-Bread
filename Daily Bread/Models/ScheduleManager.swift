//
//  ScheduleManager.swift
//  Daily Bread
//
//  Schedule Management for Daily Reminders
//

import Foundation
import UserNotifications

@MainActor
class ScheduleManager: ObservableObject {
    
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
        content.body = "Time to read your Bible verse!"
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

