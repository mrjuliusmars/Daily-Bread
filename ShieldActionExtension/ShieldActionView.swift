//
//  ShieldActionView.swift
//  Daily Bread Shield Action Extension
//

import SwiftUI
import UIKit

struct ShieldActionView: View {
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Royal blue gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.3, blue: 0.55),  // Royal blue top
                    Color(red: 0.1, green: 0.2, blue: 0.45),   // Deeper royal blue
                    Color(red: 0.05, green: 0.1, blue: 0.35)   // Dark royal blue bottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Daily Bread Logo
                if let logoImage = UIImage(named: "pngicon") {
                    Image(uiImage: logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .shadow(color: Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5), radius: 30, x: 0, y: 0)
                } else {
                    Text("🙏")
                        .font(.system(size: 100))
                }
                
                // Main heading
                Text("Your Daily Bread Awaits")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // Gold
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                
                // Body text
                VStack(spacing: 16) {
                    Text("Read a Bible verse to unlock your apps for today.")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // Ivory White
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)
                    
                    Text("Put God before social media.")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.9)) // Gold
                }
                
                Spacer()
                
                // Continue button with gold gradient
                Button(action: {
                    // Close the shield
                }) {
                    HStack(spacing: 8) {
                        Text("Continue to Daily Bread")
                            .font(.system(size: 17, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.976, blue: 0.945),
                                Color(red: 255/255, green: 235/255, blue: 0/255)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(color: Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .scaleEffect(buttonScale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        buttonScale = 0.98
                    }
                }
            }
        }
    }
}

#Preview {
    ShieldActionView()
}

