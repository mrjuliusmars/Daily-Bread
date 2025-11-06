import SwiftUI
import UIKit

struct OnboardingCarouselView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var currentPage = 0
    @State private var gradientOffset: Double = 0
    @State private var hapticGenerator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Social media is taking you away from",
            highlightedText: "God.",
            backgroundGradient: [
                Color(red: 0.05, green: 0.05, blue: 0.08),   // Deep charcoal top
                Color(red: 0.02, green: 0.02, blue: 0.05),   // Near black
                Color.black                                    // Pure black bottom
            ]
        ),
        OnboardingPage(
            title: "Bible Lock blocks your distracting apps",
            highlightedText: "automatically every day.",
            backgroundGradient: [
                Color(red: 0.05, green: 0.05, blue: 0.08),   // Deep charcoal top
                Color(red: 0.02, green: 0.02, blue: 0.05),   // Near black
                Color.black                                    // Pure black bottom
            ]
        ),
        OnboardingPage(
            title: "Read a personalized Bible verse",
            highlightedText: "to unlock them.",
            backgroundGradient: [
                Color(red: 0.05, green: 0.05, blue: 0.08),   // Deep charcoal top
                Color(red: 0.02, green: 0.02, blue: 0.05),   // Near black
                Color.black                                    // Pure black bottom
            ]
        ),
        OnboardingPage(
            title: "Put God before social media",
            highlightedText: "every single day.",
            backgroundGradient: [
                Color(red: 0.05, green: 0.05, blue: 0.08),   // Deep charcoal top
                Color(red: 0.02, green: 0.02, blue: 0.05),   // Near black
                Color.black                                    // Pure black bottom
            ]
        )
    ]
    
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
                    // Page indicators at top
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Page content
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index], currentPage: index)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    Spacer()
                    
                    // Navigation button - positioned in bottom right
                    HStack {
                        Spacer()
                        Button(action: {
                            hapticGenerator.impactOccurred()
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                // Move to quiz
                                onboardingState.navigateTo(.quiz(1))
                            }
                        }) {
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(Color(red: 0.15, green: 0.3, blue: 0.55)) // Royal blue
                                    .clipShape(Capsule())
                                    .shadow(color: Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.5), radius: 8, x: 0, y: 4)
                            } else {
                                HStack(spacing: 8) {
                                    Text("Start Quiz")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .background(Color(red: 0.15, green: 0.3, blue: 0.55)) // Royal blue
                                .clipShape(Capsule())
                                .shadow(color: Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.5), radius: 8, x: 0, y: 4)
                            }
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 50)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: currentPage)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hapticGenerator.prepare()
            gradientOffset = 0.3
        }
    }
}

struct OnboardingPage {
    let title: String
    let highlightedText: String
    var subtitle: String? = nil
    let backgroundGradient: [Color]
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let currentPage: Int
    @State private var isVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                // Main text
                Group {
                    if page.highlightedText.isEmpty {
                        // Custom formatting for simple page
                        Text("It's ") +
                        Text("simple.")
                            .foregroundColor(Color(red: 0.3, green: 0.6, blue: 0.95)) + // Lighter tint of royal blue (maintains exact 1:2:3.17 ratio)
                        Text("\nOnce a day,\nyou read a Bible verse\nto unlock your\napps.")
                    } else {
                        // Standard formatting for other pages
                        Text(page.title + " ") +
                        Text(page.highlightedText)
                            .foregroundColor(Color(red: 0.3, green: 0.6, blue: 0.95)) // Lighter tint of royal blue (maintains exact 1:2:3.17 ratio)
                    }
                }
                .font(.system(size: 42, weight: .regular, design: .serif))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineSpacing(8)
                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 30)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
        }
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingCarouselView()
            .environmentObject(OnboardingState())
    }
}

