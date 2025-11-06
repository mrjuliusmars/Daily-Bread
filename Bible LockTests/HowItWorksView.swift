import SwiftUI

struct HowItWorksView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isVisible = false
    @State private var showContent = false
    @State private var glowAnimation = false
    
    private var backgroundGradientColors: [Color] {
        [
            Color(red: 0.08, green: 0.15, blue: 0.28),
            Color(red: 0.06, green: 0.12, blue: 0.22),
            Color(red: 0.05, green: 0.1, blue: 0.2)
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: backgroundGradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Floating particles
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(isVisible ? 0.3 : 0.05)
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Main content
                    VStack(spacing: 32) {
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
                                .frame(width: 120, height: 120)
                                .blur(radius: glowAnimation ? 20 : 10)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glowAnimation)
                            
                            Image(systemName: "lock.app.dashed")
                                .font(.system(size: 50))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                .rotationEffect(.degrees(isVisible ? 360 : 0))
                                .animation(.easeOut(duration: 1.5), value: isVisible)
                        }
                        
                        // Main message
                        VStack(spacing: 16) {
                            Text("It's **simple.**")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
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
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 30)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                            
                            Text("Read your daily Bible verse\nto unlock your apps")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 30)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showContent)
                        }
                        .padding(.horizontal, 24)
                        
                        // Features
                        VStack(spacing: 20) {
                            FeatureRow(icon: "lock.fill", text: "Apps stay locked until you read", delay: 0.7)
                            FeatureRow(icon: "book.fill", text: "Daily personalized Bible verses", delay: 0.8)
                            FeatureRow(icon: "hand.raised.fill", text: "Overcome social media addiction", delay: 0.9)
                        }
                        .padding(.horizontal, 24)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.1), value: showContent)
                    }
                    
                    Spacer()
                    
                    // Continue button
                    Button(action: {
                        onboardingState.navigateTo(.quiz(1))
                    }) {
                        Text("Start Quiz")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Color(red: 1.0, green: 0.976, blue: 0.945))
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 24, 32))
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.3), value: showContent)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            glowAnimation = true
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showContent = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        HowItWorksView()
            .environmentObject(OnboardingState())
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let delay: Double
    @State private var isVisible = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                .frame(width: 32, height: 32)
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
            
            Spacer()
        }
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -20)
        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

