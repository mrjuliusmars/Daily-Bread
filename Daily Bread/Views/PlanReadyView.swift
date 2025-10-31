import SwiftUI
import UIKit

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
    
    private var backgroundGradientColors: [Color] {
        [
            Color(red: 0.15, green: 0.3, blue: 0.55),  // Royal blue top
            Color(red: 0.1, green: 0.2, blue: 0.45),   // Deeper royal blue
            Color(red: 0.05, green: 0.1, blue: 0.35)   // Dark royal blue bottom
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Royal blue gradient background
                LinearGradient(
                    colors: backgroundGradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Floating particles
                ForEach(0..<12, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 255/255, green: 250/255, blue: 205/255).opacity(0.15),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: CGFloat.random(in: 40...70))
                        .position(
                            x: Double((index % 5) * Int(geometry.size.width / 4)),
                            y: Double((index / 5) * Int(geometry.size.height / 4))
                        )
                        .opacity(0.5)
                        .blur(radius: 15)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Logo animation
                    if let logoImage = UIImage(named: "Iconpng") {
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
                        
                        isRequestingPermission = true
                        
                        Task {
                            do {
                                try await screenTimeManager.requestAuthorization()
                                // Check if authorized
                                if screenTimeManager.isAuthorized {
                                    // Show app selection screen
                                    showAppSelection = true
                                } else {
                                    // User denied, just complete onboarding
                                    completeOnboarding()
                                }
                            } catch {
                                print("Error requesting authorization: \(error)")
                                // Complete onboarding even if permission denied
                                completeOnboarding()
                            }
                            isRequestingPermission = false
                        }
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
        .onAppear {
            startAnimations()
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
