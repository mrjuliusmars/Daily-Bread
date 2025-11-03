//
//  SplashView.swift
//  Daily Bread
//
//  Splash Screen with DailyBread Logo
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var opacity: Double = 0
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
                
                // Single focused radial gradient - clean and cohesive
                RadialGradient(
                    colors: [
                        Color(red: 0.25, green: 0.5, blue: 0.85).opacity(0.5), // Lighter royal blue
                        Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.3), // Royal blue
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0.4), // Centered for balanced look
                    startRadius: 100,
                    endRadius: 500
                )
                .ignoresSafeArea()
                .blendMode(.screen)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: gradientOffset)
                
                // Subtle animated particles - evenly distributed, avoiding bottom area
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.25, green: 0.5, blue: 0.85).opacity(0.3),
                                    Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.15),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 40
                            )
                        )
                        .frame(width: 60, height: 60)
                        .position(
                            x: Double((index % 4) * Int(geometry.size.width / 3) + Int(geometry.size.width / 6)),
                            y: Double((index / 4) * Int(geometry.size.height / 4) + Int(geometry.size.height / 8)) // Changed to avoid bottom third
                        )
                        .opacity(0.5)
                        .blur(radius: 20)
                        .animation(
                            .easeInOut(duration: 6)
                            .repeatForever(autoreverses: false),
                            value: gradientOffset
                        )
                }
                
                // DailyBread Logo centered with premium effects
                ZStack {
                    // Glow effect behind logo
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.3, green: 0.6, blue: 0.95).opacity(0.4),
                                    Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.2),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .blur(radius: 30)
                        .opacity(opacity)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                    
                    // Logo shadow/outline
                    Image("pngicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .blur(radius: 15)
                        .opacity(opacity * 0.3)
                        .offset(x: 0, y: 5)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                    
                    // Main logo
                    Image("pngicon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .shadow(color: Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.8), radius: 30, x: 0, y: 10)
                        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 5)
                        .opacity(opacity)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                }
                .offset(y: -20) // Slightly higher positioning
            }
        }
        .onAppear {
            gradientOffset = 0.3
            // Staggered fade in animation for premium feel
            withAnimation(.easeOut(duration: 1.0)) {
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    isAnimating = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

