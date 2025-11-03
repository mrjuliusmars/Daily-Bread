//
//  ContentView.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct ContentView: View {
    @State private var hasReadToday = false
    @State private var showAppSelection = false
    @State private var showSettings = false
    @StateObject private var screenTimeManager = ScreenTimeManager()
    @State private var showTestAlert = false
    @State private var testAlertMessage = ""
    @State private var isBlocked = false
    @State private var gradientOffset: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium animated gradient background (Dark Mode Grey)
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.15, blue: 0.18),  // Dark grey top
                        Color(red: 0.12, green: 0.12, blue: 0.15),   // Darker grey middle
                        Color(red: 0.08, green: 0.08, blue: 0.1)    // Darkest grey bottom
                    ],
                    startPoint: UnitPoint(x: 0.5 + gradientOffset * 0.1, y: 0),
                    endPoint: UnitPoint(x: 0.5 - gradientOffset * 0.1, y: 1)
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: gradientOffset)
                
                // Additional depth layer with royal blue accent (exact same hue, lighter)
                RadialGradient(
                    colors: [
                        Color(red: 0.25, green: 0.5, blue: 0.85).opacity(0.4), // Lighter tint of royal blue (maintains 1:2:3.4 ratio)
                        Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.25), // Exact royal blue
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.7 + gradientOffset * 0.05, y: 0.3),
                    startRadius: 50,
                    endRadius: 500
                )
                .ignoresSafeArea()
                .blendMode(.screen)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: gradientOffset)
                
                // Enhanced animated particles (royal blue - exact hue) - stable position per page
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.25, green: 0.5, blue: 0.85).opacity(0.35), // Lighter tint of royal blue
                                    Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.2), // Exact royal blue
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: CGFloat.random(in: 40...80))
                        .position(
                            x: Double((index % 5) * Int(geometry.size.width / 4)),
                            y: Double((index / 5) * Int(geometry.size.height / 4))
                        )
                        .opacity(0.6)
                        .blur(radius: 20)
                        .animation(
                            .easeInOut(duration: 8)
                            .repeatForever(autoreverses: false),
                            value: gradientOffset
                        )
                }
                
                VStack(spacing: 0) {
                    // Status bar area (top safe area)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.top)
                    
                    // Top navigation buttons
                    HStack {
                        Spacer()
                        
                        // Settings button (top right)
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            showSettings = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.15, green: 0.3, blue: 0.55)) // Royal blue
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    // Main content area - Praying hands
                    VStack(spacing: 20) {
                        // Praying hands icon with sparkles
                        ZStack {
                            Image(systemName: "hand.raised.fill")
                                .font(.system(size: 120))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                            
                            // Sparkles around the hands
                            ForEach(0..<3) { index in
                                Image(systemName: "sparkle")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                    .offset(
                                        x: CGFloat(index - 1) * 50,
                                        y: index == 0 ? -30 : 30
                                    )
                            }
                        }
                        
                        Text("Your bible verse will appear here")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Test Blocking Button (for debugging)
                    Button(action: {
                        testBlocking()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: isBlocked ? "lock.fill" : "lock.open.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text(isBlocked ? "Unblock Apps (Test)" : "Test Block Apps Now")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.8)) // Royal blue
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 1.0, green: 0.976, blue: 0.945), lineWidth: 1)
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
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            
                            Text("🙏")
                                .font(.system(size: 20))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.15, green: 0.3, blue: 0.55)) // Royal blue
                        )
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAppSelection) {
            AppSelectionView(isPresented: $showAppSelection)
                .environmentObject(screenTimeManager)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .alert("Test Result", isPresented: $showTestAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(testAlertMessage)
        }
        .onAppear {
            gradientOffset = 0.3
        }
    }
    
    private func testBlocking() {
        if isBlocked {
            // Unblock apps
            let store = ManagedSettingsStore(named: .main)
            store.clearAllSettings()
            isBlocked = false
            testAlertMessage = "✅ Apps have been unblocked! Try opening one of your blocked apps to verify."
            showTestAlert = true
            print("🧪 TEST: Apps unblocked manually")
        } else {
            // Block apps - check all possible locations
            let appGroupDefaults = UserDefaults(suiteName: "group.com.mjhventures.dailybread")
            let standardDefaults = UserDefaults.standard
            
            print("🧪 TEST: Checking for saved app selection...")
            print("🧪 TEST: App Group exists: \(appGroupDefaults != nil)")
            
            // Check for saved app selection in both places
            var savedData: Data? = nil
            var dataSource = ""
            
            if let appGroupData = appGroupDefaults?.data(forKey: "selectedApps"), !appGroupData.isEmpty {
                savedData = appGroupData
                dataSource = "App Group"
                print("🧪 TEST: Found data in App Group (\(appGroupData.count) bytes)")
            } else if let standardData = standardDefaults.data(forKey: "selectedApps"), !standardData.isEmpty {
                savedData = standardData
                dataSource = "Standard"
                print("🧪 TEST: Found data in Standard UserDefaults (\(standardData.count) bytes)")
            } else {
                print("🧪 TEST: No data found in either location")
                print("🧪 TEST: App Group has key: \(appGroupDefaults?.object(forKey: "selectedApps") != nil)")
                print("🧪 TEST: Standard has key: \(standardDefaults.object(forKey: "selectedApps") != nil)")
            }
            
            if let data = savedData {
                do {
                    let selection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
                    let appTokens = selection.applicationTokens
                    let categoryTokens = selection.categoryTokens
                    let webTokens = selection.webDomainTokens
                    
                    print("🧪 TEST: Decoded selection successfully")
                    print("🧪 TEST: Application tokens: \(appTokens.count)")
                    print("🧪 TEST: Category tokens: \(categoryTokens.count)")
                    print("🧪 TEST: Web domain tokens: \(webTokens.count)")
                    print("🧪 TEST: Total selection items: \(appTokens.count + categoryTokens.count + webTokens.count)")
                    
                    // Check if we have any tokens at all
                    let hasAnyTokens = !appTokens.isEmpty || !categoryTokens.isEmpty || !webTokens.isEmpty
                    
                    if !hasAnyTokens {
                        testAlertMessage = "❌ No apps/categories were selected.\n\nData source: \(dataSource)\n\nPlease go to 'Apps You Blocked' and select some apps first."
                        showTestAlert = true
                        return
                    }
                    
                    // Apply shields immediately
                    let store = ManagedSettingsStore(named: .main)
                    
                    // Apply application shields
                    if !appTokens.isEmpty {
                        store.shield.applications = appTokens
                        print("🧪 TEST: Applied shields to \(appTokens.count) apps")
                    }
                    
                    // Apply category shields
                    if !categoryTokens.isEmpty {
                        store.shield.applicationCategories = .specific(categoryTokens)
                        print("🧪 TEST: Applied shields to \(categoryTokens.count) categories")
                    }
                    
                    // Note: Web domain tokens need to be handled differently
                    // For now, we'll focus on apps and categories which are the main use case
                    if !webTokens.isEmpty {
                        print("🧪 TEST: Note: \(webTokens.count) web domains selected (not blocking web domains in test)")
                    }
                    
                    let totalItems = appTokens.count + categoryTokens.count + webTokens.count
                    isBlocked = true
                    testAlertMessage = "✅ Apps are now blocked!\n\n• \(appTokens.count) apps\n• \(categoryTokens.count) categories\n• \(webTokens.count) web domains\n\nTotal: \(totalItems) items\n\nTry opening one of your selected apps to see the shield screen."
                    showTestAlert = true
                    print("🧪 TEST: Manually blocked \(totalItems) items")
                    NSLog("🧪 TEST: Manually blocked \(totalItems) items from \(dataSource)")
                } catch {
                    testAlertMessage = "❌ Error: Failed to decode saved app selection.\n\nData source: \(dataSource)\nError: \(error.localizedDescription)\n\nTry reselecting your apps."
                    showTestAlert = true
                    print("🧪 TEST ERROR: \(error)")
                    print("🧪 TEST ERROR: Data was \(data.count) bytes")
                }
            } else {
                testAlertMessage = "❌ No saved app selection found.\n\nPlease complete onboarding and select apps first, or go to 'Apps You Blocked' to reselect."
                showTestAlert = true
                print("🧪 TEST ERROR: No saved app selection found in any location")
            }
        }
    }
}

// Extension for ManagedSettingsStore name to match monitor extension
extension ManagedSettingsStore.Name {
    static let main = ManagedSettingsStore.Name("main")
}

#Preview {
    ContentView()
}
