//
//  Bible_LockApp.swift
//  Bible Lock
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI
import SuperwallKit

@main
struct Bible_LockApp: App {
    @StateObject private var onboardingState = OnboardingState()
    @State private var hasCompletedOnboarding = false
    @State private var showSplash = true
    
    init() {
        // Configure Superwall
        Superwall.configure(apiKey: "pk_C8cldqMI26f1HGQ9ZWkiA")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView()
                        .onAppear {
                            // Show splash for 2 seconds, then transition
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showSplash = false
                                }
                            }
                        }
                } else if hasCompletedOnboarding {
                    ContentView()
                } else {
                    OnboardingFlowView(
                        onboardingState: onboardingState,
                        onOnboardingComplete: {
                            hasCompletedOnboarding = true
                        }
                    )
                }
            }
            .onAppear {
                loadOnboardingStatus()
            }
        }
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}
