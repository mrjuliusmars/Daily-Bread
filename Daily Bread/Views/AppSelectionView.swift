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
                            // Force a small delay to ensure picker selection is fully updated
                            Task { @MainActor in
                                // Give the picker a moment to finalize the selection
                                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                                
                                // Debug: Log the selection before applying
                                print("🔍 DEBUG: Selected apps count: \(selectedApps.applicationTokens.count)")
                                print("🔍 DEBUG: Selected categories count: \(selectedApps.categoryTokens.count)")
                                print("🔍 DEBUG: Selected web domains count: \(selectedApps.webDomainTokens.count)")
                                NSLog("🔍 DEBUG: FamilyActivitySelection - Apps: \(selectedApps.applicationTokens.count), Categories: \(selectedApps.categoryTokens.count)")
                                
                                await applyAppBlocking()
                            }
                            isPresented = false
                        }
                        .disabled(selectedApps.applicationTokens.isEmpty && selectedApps.categoryTokens.isEmpty && selectedApps.webDomainTokens.isEmpty)
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
            // Load saved selection immediately - FamilyActivityPicker needs it before rendering
            // The picker can restore selections properly if set before it appears
            loadSavedSelection()
        }
        .onChange(of: selectedApps) { oldValue, newValue in
            // Debug: Track when selection changes
            print("🔍 DEBUG: FamilyActivityPicker selection changed!")
            print("🔍 DEBUG: Apps: \(newValue.applicationTokens.count), Categories: \(newValue.categoryTokens.count)")
            NSLog("🔍 DEBUG: Selection changed - Apps: \(newValue.applicationTokens.count)")
        }
    }
    
    private func loadSavedSelection() {
        // Load previously saved app selection from UserDefaults
        // IMPORTANT: Use standard UserDefaults (more reliable)
        // IMPORTANT: Set synchronously so picker sees it before rendering
        let standardDefaults = UserDefaults.standard
        
        if let savedData = standardDefaults.data(forKey: "selectedApps"),
           let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: savedData) {
            // Update selection directly (we're already on MainActor via @State)
            selectedApps = decoded
            print("📱 Loaded saved selection:")
            print("   - Apps: \(decoded.applicationTokens.count)")
            print("   - Categories: \(decoded.categoryTokens.count)")
            print("   - Web Domains: \(decoded.webDomainTokens.count)")
            NSLog("📱 Loaded saved selection - Apps: \(decoded.applicationTokens.count), Categories: \(decoded.categoryTokens.count)")
        } else {
            print("📱 No saved selection found (this is normal for first time)")
        }
    }
    
    private func applyAppBlocking() async {
        // IMPORTANT: Ensure we're on the main actor to access @State variable
        await MainActor.run {
            // Debug logging
            print("🔍 DEBUG applyAppBlocking: Starting")
            print("🔍 DEBUG: selectedApps.applicationTokens.count = \(selectedApps.applicationTokens.count)")
            print("🔍 DEBUG: selectedApps.categoryTokens.count = \(selectedApps.categoryTokens.count)")
            
            // Check if we have ANY selection (apps, categories, or web domains)
            let hasSelection = !selectedApps.applicationTokens.isEmpty || 
                              !selectedApps.categoryTokens.isEmpty || 
                              !selectedApps.webDomainTokens.isEmpty
            
            if !hasSelection {
                print("❌ ERROR: FamilyActivityPicker selection is empty!")
                print("❌ ERROR: User tapped Done but no apps/categories were selected")
                print("❌ ERROR: This might be a picker binding issue")
                NSLog("❌ ERROR: FamilyActivityPicker returned empty selection")
                return
            }
            
            // Get application tokens from the selection
            let storeName = ManagedSettingsStore.Name("main")
            let store = ManagedSettingsStore(named: storeName)
            
            // Apply the shield to selected applications
            store.shield.applications = selectedApps.applicationTokens
            
            // IMPORTANT: Also apply categories if selected
            // Categories block ALL apps within those categories
            if !selectedApps.categoryTokens.isEmpty {
                store.shield.applicationCategories = .specific(selectedApps.categoryTokens)
                print("✅ Category-based blocking enabled for \(selectedApps.categoryTokens.count) categories")
                print("   Note: All apps within selected categories will be blocked")
            }
            
            let appCount = selectedApps.applicationTokens.count
            let categoryCount = selectedApps.categoryTokens.count
            
            print("✅ Blocking Summary:")
            print("   - Individual Apps: \(appCount)")
            print("   - Categories: \(categoryCount) (blocks all apps in category)")
            
            // Log what will actually be blocked
            if categoryCount > 0 && appCount == 0 {
                print("✅ Blocking mode: CATEGORY-BASED")
                print("   All apps in \(categoryCount) selected category/categories will be blocked")
                NSLog("✅ Category blocking: \(categoryCount) categories selected")
            } else if appCount > 0 && categoryCount == 0 {
                print("✅ Blocking mode: INDIVIDUAL APPS")
                print("   \(appCount) specific apps will be blocked")
                NSLog("✅ App blocking: \(appCount) apps selected")
            } else if appCount > 0 && categoryCount > 0 {
                print("✅ Blocking mode: MIXED")
                print("   \(appCount) individual apps + \(categoryCount) categories will be blocked")
                NSLog("✅ Mixed blocking: \(appCount) apps + \(categoryCount) categories")
            }
            
            // Warn if nothing selected
            if appCount == 0 && categoryCount == 0 {
                print("⚠️ WARNING: No apps or categories were selected! Blocking will not work.")
                NSLog("⚠️ WARNING: No apps or categories selected - DeviceActivity schedule registered but will have no effect")
            } else {
                // Get user's blocking time (or default)
                let hour = UserDefaults.standard.object(forKey: "blockingHour") as? Int ?? 14
                let minute = UserDefaults.standard.object(forKey: "blockingMinute") as? Int ?? 37
                let hour12 = hour % 12 == 0 ? 12 : hour % 12
                let amPm = hour < 12 ? "AM" : "PM"
                let timeString = String(format: "%d:%02d %@", hour12, minute, amPm)
                print("🔒 Apps will auto-lock at \(timeString) daily")
            }
        }
        
        // IMPORTANT: Capture the selection value NOW, before any async work
        // The @State variable might be cleared if view is dismissed
        let selectionToSave = await MainActor.run { selectedApps }
        
        // Save selection to UserDefaults for persistence
        // IMPORTANT: Only use standard UserDefaults to avoid App Group container warnings
        // Extensions can still access standard UserDefaults on the same device
        let standardDefaults = UserDefaults.standard
        
        // Debug: Log what we're about to save
        print("🔍 DEBUG: About to save selection:")
        print("   - Apps: \(selectionToSave.applicationTokens.count)")
        print("   - Categories: \(selectionToSave.categoryTokens.count)")
        print("   - Web Domains: \(selectionToSave.webDomainTokens.count)")
        
        // Try to encode
        if let encoded = try? JSONEncoder().encode(selectionToSave) {
            // Save to standard UserDefaults (works reliably for extensions)
            standardDefaults.set(encoded, forKey: "selectedApps")
            standardDefaults.synchronize()
            
            // Also try App Group if available (for debugging, but don't rely on it)
            if let appGroupDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread") {
                appGroupDefaults.set(encoded, forKey: "selectedApps")
                appGroupDefaults.synchronize()
            }
            
            print("✅ Saved selection to UserDefaults:")
            print("   - Apps: \(selectionToSave.applicationTokens.count)")
            print("   - Categories: \(selectionToSave.categoryTokens.count)")
            print("   - Total items: \(selectionToSave.applicationTokens.count + selectionToSave.categoryTokens.count)")
            print("✅ Saved to standard UserDefaults: Yes")
            
            // Verify the save
            if standardDefaults.data(forKey: "selectedApps") != nil {
                print("✅ Verified: Data exists in standard UserDefaults")
                if let verifyData = standardDefaults.data(forKey: "selectedApps"),
                   let verifyDecoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: verifyData) {
                    print("✅ Verified: Decoded back successfully")
                    print("   - Apps: \(verifyDecoded.applicationTokens.count)")
                    print("   - Categories: \(verifyDecoded.categoryTokens.count)")
                    
                    if verifyDecoded.applicationTokens.count == 0 && verifyDecoded.categoryTokens.count == 0 {
                        print("⚠️ WARNING: Saved selection has 0 apps AND 0 categories - encoding may have lost data")
                        NSLog("⚠️ WARNING: Encoded FamilyActivitySelection appears completely empty")
                    } else if verifyDecoded.applicationTokens.count == 0 && verifyDecoded.categoryTokens.count > 0 {
                        print("ℹ️ INFO: Using category-based blocking (no individual apps)")
                        NSLog("ℹ️ INFO: \(verifyDecoded.categoryTokens.count) categories saved, 0 individual apps")
                    }
                }
            }
        } else {
            print("❌ Failed to encode FamilyActivitySelection")
            print("❌ This is a critical error - app selection cannot be saved")
            NSLog("❌ CRITICAL: Failed to encode FamilyActivitySelection")
        }
        
        // Update the blocking settings with the captured selection
        scheduleManager.applyDailyBlocking(applicationTokens: selectionToSave.applicationTokens)
        
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
