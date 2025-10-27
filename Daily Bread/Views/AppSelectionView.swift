//
//  AppSelectionView.swift
//  Daily Bread
//
//  App Selection Screen - Placeholder (app blocking removed)
//

import SwiftUI

struct AppSelectionView: View {
    @EnvironmentObject var screenTimeManager: ScreenTimeManager
    @Binding var isPresented: Bool
    var onComplete: (() -> Void)?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "apps.iphone")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("App Blocking Unavailable")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("This feature requires Family Controls permission from Apple. You can proceed without it.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                
                Button("Continue Without Blocking") {
                    completeOnboarding()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Choose Activities")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
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
