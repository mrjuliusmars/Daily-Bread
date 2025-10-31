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
    
    var body: some View {
        ZStack {
            // Royal blue gradient background (same as other views)
            LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.3, blue: 0.55),  // Royal blue top
                    Color(red: 0.1, green: 0.2, blue: 0.45),   // Deeper royal blue
                    Color(red: 0.05, green: 0.1, blue: 0.35)   // Dark royal blue bottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // DailyBread Logo centered
            Image("Iconpng")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(opacity)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
        }
        .onAppear {
            // Fade in animation
            withAnimation(.easeIn(duration: 0.8)) {
                opacity = 1.0
                isAnimating = true
            }
        }
    }
}

#Preview {
    SplashView()
}

