//
//  HomeTabView.swift
//  Daily Bread
//
//  Home tab - main screen with daily verse button
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct HomeTabView: View {
    @State private var hasReadToday = false
    @State private var showAppSelection = false
    @State private var showBibleView = false
    @StateObject private var screenTimeManager = ScreenTimeManager()
    @StateObject private var verseManager = DailyVerseManager.shared
    @State private var showTestAlert = false
    @State private var testAlertMessage = ""
    @State private var isBlocked = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Blurred background image from current verse
                if let verse = verseManager.todaysVerse {
                    Image(verse.backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                        .blur(radius: 20)
                        .overlay(
                            // Gradient overlay to darken edges and prevent white artifacts
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.4), // Darker at top
                                    Color.black.opacity(0.3), // Middle
                                    Color.black.opacity(0.4)  // Darker at bottom
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    // Fallback gradient if no verse loaded
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.15, blue: 0.18),
                            Color(red: 0.12, green: 0.12, blue: 0.15),
                            Color(red: 0.08, green: 0.08, blue: 0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    // Status bar area (top safe area)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.top)
                    
                    Spacer()
                    
                    // Main content area - Read Today's Verse Button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        showBibleView = true
                    }) {
                        VStack(spacing: 20) {
                            // Praying hands icon with sparkles
                            ZStack {
                                Image(systemName: "hand.raised.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(.black.opacity(0.9))
                                
                                // Sparkles around the hands
                                ForEach(0..<3) { index in
                                    Image(systemName: "sparkle")
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                        .offset(
                                            x: CGFloat(index - 1) * 45,
                                            y: index == 0 ? -25 : 25
                                        )
                                }
                            }
                            
                            Text("Read Today's Verse")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Unlock your apps by reading God's word")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.black.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                                )
                        )
                        .padding(.horizontal, 32)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Test Blocking Button
                    Button(action: {
                        testBlocking()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: isBlocked ? "lock.fill" : "lock.open.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text(isBlocked ? "Unblock Apps (Test)" : "Test Block Apps Now")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 8)
                    
                    // Bottom button - Apps You Blocked
                    Button(action: {
                        showAppSelection = true
                    }) {
                        HStack(spacing: 12) {
                            Text("Apps You Blocked")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("🙏")
                                .font(.system(size: 20))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 70, 90)) // Space for bottom nav
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAppSelection) {
            AppSelectionView(isPresented: $showAppSelection)
                .environmentObject(screenTimeManager)
        }
        .fullScreenCover(isPresented: $showBibleView) {
            BibleViewWithNav()
        }
        .alert("Test Result", isPresented: $showTestAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(testAlertMessage)
        }
    }
    
    private func testBlocking() {
        if isBlocked {
            let store = ManagedSettingsStore(named: .main)
            store.clearAllSettings()
            isBlocked = false
            testAlertMessage = "✅ Apps have been unblocked!"
            showTestAlert = true
        } else {
            let appGroupDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread")
            let standardDefaults = UserDefaults.standard
            
            var savedData: Data? = nil
            var dataSource = ""
            
            if let appGroupData = appGroupDefaults?.data(forKey: "selectedApps"), !appGroupData.isEmpty {
                savedData = appGroupData
                dataSource = "App Group"
            } else if let standardData = standardDefaults.data(forKey: "selectedApps"), !standardData.isEmpty {
                savedData = standardData
                dataSource = "Standard"
            }
            
            if let data = savedData {
                do {
                    let selection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
                    let appTokens = selection.applicationTokens
                    let categoryTokens = selection.categoryTokens
                    let webTokens = selection.webDomainTokens
                    
                    let hasAnyTokens = !appTokens.isEmpty || !categoryTokens.isEmpty || !webTokens.isEmpty
                    
                    if !hasAnyTokens {
                        testAlertMessage = "❌ No apps selected. Please select apps first."
                        showTestAlert = true
                        return
                    }
                    
                    let store = ManagedSettingsStore(named: .main)
                    
                    if !appTokens.isEmpty {
                        store.shield.applications = appTokens
                    }
                    
                    if !categoryTokens.isEmpty {
                        store.shield.applicationCategories = .specific(categoryTokens)
                    }
                    
                    let totalItems = appTokens.count + categoryTokens.count + webTokens.count
                    isBlocked = true
                    testAlertMessage = "✅ Apps are now blocked!\n\n• \(appTokens.count) apps\n• \(categoryTokens.count) categories\n\nTotal: \(totalItems) items"
                    showTestAlert = true
                } catch {
                    testAlertMessage = "❌ Error: Failed to decode saved app selection."
                    showTestAlert = true
                }
            } else {
                testAlertMessage = "❌ No saved app selection found. Please select apps first."
                showTestAlert = true
            }
        }
    }
}

#Preview {
    HomeTabView()
}

