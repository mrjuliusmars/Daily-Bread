//
//  ScreenTimeManager.swift
//  Daily Bread
//
//  Screen Time Management using FamilyControls
//

import Foundation
import FamilyControls
import ManagedSettings

@MainActor
class ScreenTimeManager: ObservableObject {
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    @Published var isAuthorized = false
    
    private let authorizationCenter = AuthorizationCenter.shared
    
    init() {
        Task {
            await checkAuthorization()
        }
    }
    
    func requestAuthorization() async throws {
        do {
            try await authorizationCenter.requestAuthorization(for: .individual)
            await checkAuthorization()
        } catch {
            print("Screen Time authorization error: \(error)")
            throw error
        }
    }
    
    func checkAuthorization() async {
        authorizationStatus = authorizationCenter.authorizationStatus
        isAuthorized = (authorizationStatus == .approved)
    }
    
    func createAppShield(applicationTokens: Set<ApplicationToken>) {
        let storeName = ManagedSettingsStore.Name("main")
        let store = ManagedSettingsStore(named: storeName)
        store.clearAllSettings()
        store.shield.applications = applicationTokens
    }
}


