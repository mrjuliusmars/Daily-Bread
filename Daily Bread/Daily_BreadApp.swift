//
//  Daily_BreadApp.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI

@main
struct Daily_BreadApp: App {
    @StateObject private var onboardingState = OnboardingState()
    @State private var hasCompletedOnboarding = false
    @State private var showSplash = true
    
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
