//
//  AppSelectionView.swift
//  Daily Bread
//
//  App Selection Screen for Screen Time
//

import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

struct AppSelectionView: View {
    @EnvironmentObject var screenTimeManager: ScreenTimeManager
    @StateObject private var scheduleManager = ScheduleManager()
    @State private var selectedApps = FamilyActivitySelection()
    @Binding var isPresented: Bool
    var onComplete: (() -> Void)?
    
    var body: some View {
        NavigationView {
            // Family Activity Picker with system styling
            FamilyActivityPicker(selection: $selectedApps)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            Task {
                                await applyAppBlocking()
                            }
                            isPresented = false
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Choose Activities")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
        }
        .onAppear {
            loadSavedSelection()
        }
    }
    
    private func loadSavedSelection() {
        // Load previously saved app selection from UserDefaults
        // Try App Group first, fallback to standard
        let userDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread") ?? UserDefaults.standard
        
        if let savedData = userDefaults.data(forKey: "selectedApps"),
           let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: savedData) {
            selectedApps = decoded
            print("📱 Loaded saved app selection (count: \(decoded.applicationTokens.count))")
        }
    }
    
    private func applyAppBlocking() async {
        // Get application tokens from the selection
        let storeName = ManagedSettingsStore.Name("main")
        let store = ManagedSettingsStore(named: storeName)
        
        // Set up the shield - this will block apps
        // The scheduling happens automatically when using ManagedSettings
        // with DeviceActivity framework
        
        // Apply the shield to selected applications
        store.shield.applications = selectedApps.applicationTokens
        
        print("✅ Apps blocked: \(selectedApps.applicationTokens.count)")
        print("🔒 Apps will auto-lock at 4 AM daily")
        
        // Save selection to UserDefaults for persistence
        // Save to BOTH App Group AND standard UserDefaults to ensure extension can access it
        let appGroupDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread")
        let standardDefaults = UserDefaults.standard
        
        // Try to encode
        if let encoded = try? JSONEncoder().encode(selectedApps) {
            // Save to App Group (if available)
            appGroupDefaults?.set(encoded, forKey: "selectedApps")
            appGroupDefaults?.synchronize()
            
            // Also save to standard UserDefaults as backup
            standardDefaults.set(encoded, forKey: "selectedApps")
            standardDefaults.synchronize()
            
            let tokenCount = selectedApps.applicationTokens.count
            print("✅ Saved app selection to UserDefaults (count: \(tokenCount))")
            print("✅ Saved to App Group: \(appGroupDefaults != nil ? "Yes" : "No")")
            print("✅ Saved to standard UserDefaults: Yes")
            
            // Verify the save
            if appGroupDefaults?.data(forKey: "selectedApps") != nil {
                print("✅ Verified: Data exists in App Group UserDefaults")
            }
            if standardDefaults.data(forKey: "selectedApps") != nil {
                print("✅ Verified: Data exists in standard UserDefaults")
            }
        } else {
            print("❌ Failed to encode FamilyActivitySelection")
            print("❌ This is a critical error - app selection cannot be saved")
        }
        
        // Update the blocking settings
        scheduleManager.applyDailyBlocking(applicationTokens: selectedApps.applicationTokens)
        
        print("✅ Blocking settings updated")
        
        // Complete onboarding and go to ContentView
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        NotificationCenter.default.post(name: Notification.Name("OnboardingCompleted"), object: nil)
        
        // Call the completion handler if provided
        onComplete?()
    }
}

#Preview {
    AppSelectionView(isPresented: .constant(true))
        .environmentObject(ScreenTimeManager())
}
