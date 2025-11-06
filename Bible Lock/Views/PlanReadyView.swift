import SwiftUI
import UIKit
import SuperwallKit

// Preview helper to create OnboardingState
private func createPreviewOnboardingState() -> OnboardingState {
    let state = OnboardingState()
    state.name = "John"
    state.age = "25"
    return state
}

struct PlanReadyView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @StateObject private var screenTimeManager = ScreenTimeManager()
    @State private var isVisible = false
    @State private var logoScale: CGFloat = 0.5
    @State private var contentOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 30
    @State private var showAppSelection = false
    @State private var isRequestingPermission = false
    @State private var gradientOffset: Double = 0
    @State private var hasRequestedScreenTime = false
    @State private var showPermissionDeniedAlert = false
    
    private var backgroundGradientColors: [Color] {
        [
            Color(red: 0.15, green: 0.15, blue: 0.18),  // Dark grey top
            Color(red: 0.12, green: 0.12, blue: 0.15),   // Darker grey middle
            Color(red: 0.08, green: 0.08, blue: 0.1)    // Darkest grey bottom
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium animated gradient background (Dark Mode Grey)
                LinearGradient(
                    colors: backgroundGradientColors,
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
                    Spacer()
                    
                    // Logo animation
                    if let logoImage = UIImage(named: "pngicon") {
                        Image(uiImage: logoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .shadow(color: Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5), radius: 30, x: 0, y: 0)
                            .scaleEffect(logoScale)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: logoScale)
                    }
                    
                    Spacer().frame(height: 50)
                    
                    // Main content
                    VStack(spacing: 20) {
                        // Success message
                        VStack(spacing: 12) {
                            Text("Your Journey is Ready!")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.976, blue: 0.945),
                                            Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(contentOpacity)
                        .offset(y: contentOpacity == 1 ? 0 : 20)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.8), value: contentOpacity)
                        
                            // Features
                            VStack(spacing: 16) {
                                PlanReadyFeatureRow(icon: "book.fill", title: "Daily Bible Verses", description: "Verses tailored to your struggles")
                                PlanReadyFeatureRow(icon: "lock.app.dashed", title: "App Lock", description: "Read a Bible verse to unlock your apps")
                                PlanReadyFeatureRow(icon: "heart.fill", title: "Spiritual Growth", description: "Track your journey daily")
                            }
                        .opacity(contentOpacity)
                        .offset(y: contentOpacity == 1 ? 0 : 20)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.1), value: contentOpacity)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Start Journey button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        // Register Superwall placement trigger - this will show the paywall
                        Superwall.shared.register(placement: "start_your_journey")
                    }) {
                        HStack(spacing: 12) {
                            Text("Start Your Journey")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.85)
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5), radius: 25, x: 0, y: 10)
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.4), Color.clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 2
                                )
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 24, 32))
                    .opacity(contentOpacity)
                    .offset(y: buttonOffset)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.5), value: contentOpacity)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.5), value: buttonOffset)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAppSelection) {
            AppSelectionView(isPresented: $showAppSelection)
                .environmentObject(screenTimeManager)
        }
        .alert("Screen Time Permission Required", isPresented: $showPermissionDeniedAlert) {
            Button("Continue") {
                // Request permission again automatically
                requestScreenTimePermission()
            }
        } message: {
            Text("Bible Lock can't work without Screen Time permission. Please press Continue and allow Screen Time access to continue.")
        }
        .onAppear {
            gradientOffset = 0.3
            startAnimations()
            setupSuperwallSubscriptionListener()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SuperwallSubscriptionActive"))) { _ in
            // When subscription becomes active (after paywall/trial sign-up)
            if !hasRequestedScreenTime {
                hasRequestedScreenTime = true
                requestScreenTimePermission()
            }
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        NotificationCenter.default.post(name: Notification.Name("OnboardingCompleted"), object: nil)
    }
    
    private func startAnimations() {
        withAnimation {
            logoScale = 1.0
            isVisible = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            contentOpacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            buttonOffset = 0
        }
    }
    
    private func setupSuperwallSubscriptionListener() {
        // Check subscription status periodically after paywall
        Task {
            // Wait a bit for paywall to potentially complete
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // Check if subscription is active
            let status = Superwall.shared.subscriptionStatus
            if case .active = status, !hasRequestedScreenTime {
                hasRequestedScreenTime = true
                await MainActor.run {
                    requestScreenTimePermission()
                }
            }
        }
    }
    
    private func requestScreenTimePermission() {
        isRequestingPermission = true
        
        Task {
            do {
                try await screenTimeManager.requestAuthorization()
                // Check authorization status after request
                await screenTimeManager.checkAuthorization()
                
                await MainActor.run {
                    if screenTimeManager.isAuthorized {
                        // Show app selection screen
                        showAppSelection = true
                        isRequestingPermission = false
                    } else {
                        // User denied - show alert explaining app can't work without it
                        isRequestingPermission = false
                        showPermissionDeniedAlert = true
                    }
                }
            } catch {
                print("Error requesting authorization: \(error)")
                // Check status after error
                await screenTimeManager.checkAuthorization()
                
                await MainActor.run {
                    isRequestingPermission = false
                    if !screenTimeManager.isAuthorized {
                        // Show alert to prompt again
                        showPermissionDeniedAlert = true
                    } else {
                        // Somehow authorized, show app selection
                        showAppSelection = true
                    }
                }
            }
        }
    }
}

struct PlanReadyFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.2),
                                Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.4), lineWidth: 1.5)
                    )
                    .shadow(color: Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    NavigationStack {
        PlanReadyView()
            .environmentObject(createPreviewOnboardingState())
    }
}
