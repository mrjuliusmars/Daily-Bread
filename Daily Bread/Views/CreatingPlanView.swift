import SwiftUI
import UIKit

struct CreatingPlanView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var progress: CGFloat = 0
    @State private var currentMessage = 0
    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var dotsOffset: CGFloat = 0
    @State private var hapticGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private let messages = [
        "Analyzing your spiritual journey...",
        "Matching verses to your struggles...",
        "Creating your personalized plan...",
        "Almost ready..."
    ]
    
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
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Animated Daily Bread logo (open book with cross)
                    ZStack {
                        // Rotating background glow
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.2),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                            .blur(radius: 20)
                            .rotationEffect(.degrees(rotation))
                            .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: rotation)
                        
                        // Pulsing circle
                        Circle()
                            .stroke(
                                Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.3),
                                lineWidth: 2
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulseScale)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseScale)
                        
                        // Daily Bread logo
                        Group {
                            if let logoImage = UIImage(named: "DailyBread_Transparent") {
                                Image(uiImage: logoImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 6)
                            } else {
                                // Fallback if image not found
                                Text("DAILY\nBREAD")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                    .multilineTextAlignment(.center)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                        }
                        .scaleEffect(0.9 + progress * 0.1)
                    }
                    
                    // Loading message
                    VStack(spacing: 16) {
                        Text(messages[currentMessage])
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            .multilineTextAlignment(.center)
                            .animation(.easeInOut(duration: 0.5), value: currentMessage)
                        
                        // Animated dots
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Color(red: 255/255, green: 215/255, blue: 0/255))
                                    .frame(width: 8, height: 8)
                                    .offset(y: dotsOffset * (index % 2 == 0 ? 1 : -1))
                                    .opacity(0.6 + Double(index) * 0.2)
                                    .animation(
                                        .easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                        value: dotsOffset
                                    )
                            }
                        }
                    }
                    
                    // Progress bar
                    GeometryReader { progressGeometry in
                        ZStack(alignment: .leading) {
                            // Background
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 4)
                            
                            // Progress
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 255/255, green: 215/255, blue: 0/255),
                                            Color(red: 255/255, green: 215/255, blue: 0/255).opacity(0.7)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(0, progressGeometry.size.width * progress), height: 4)
                                .clipped()
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 60)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hapticGenerator.prepare()
            startLoading()
        }
    }
    
    private func startLoading() {
        // Ensure progress starts at 0
        progress = 0
        
        // Set rotation to start animation
        rotation = 360
        
        // Start pulsing
        pulseScale = 1.2
        
        // Start dots animation
        dotsOffset = -5
        
        // Animate progress from 0 to 100% over 6 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 6)) {
                progress = 1.0
            }
        }
        
        // Cycle through messages with haptic feedback
        for i in 0..<messages.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.5) {
                hapticGenerator.impactOccurred(intensity: 0.6 + CGFloat(i) * 0.1)
                withAnimation {
                    currentMessage = i
                }
            }
        }
        
        // Navigate to plan ready after loading completes with completion haptic
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            let successGenerator = UINotificationFeedbackGenerator()
            successGenerator.notificationOccurred(.success)
            onboardingState.navigateTo(.planReady)
        }
    }
}

#Preview {
    NavigationStack {
        CreatingPlanView()
            .environmentObject(OnboardingState())
    }
}

