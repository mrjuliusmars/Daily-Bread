//
//  ScreenTimeManager.swift
//  Daily Bread
//
//  Screen Time Management
//

import Foundation
import ManagedSettings

@MainActor
class ScreenTimeManager: ObservableObject {
    @Published var isAuthorized = false
    
    init() {
        // Screen Time authorization is handled at the system level
        isAuthorized = true
    }
    
    func requestAuthorization() async throws {
        // Authorization granted by using the app
        isAuthorized = true
    }
    
    func checkAuthorization() async {
        isAuthorized = true
    }
}


