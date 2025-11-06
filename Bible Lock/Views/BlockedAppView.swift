//
//  BlockedAppView.swift
//  Daily Bread
//
//  Landing page when user tries to open blocked apps
//

import SwiftUI

struct BlockedAppView: View {
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // Praying hands emoji
                Text("🙏")
                    .font(.system(size: 100))
                
                // Main heading
                Text("Pause and Pray!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Body text
                VStack(spacing: 16) {
                    Text("Take a moment to reflect and reconnect with your faith before diving into your apps.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)
                    
                    HStack(spacing: 8) {
                        Text("Open Bible Lock")
                        Text("🙏")
                            .font(.system(size: 20))
                    }
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                }
                
                Spacer()
                
                // OK button
                Button(action: {
                    // Close the view and go back
                    // This will be handled by the DeviceActivity shield
                }) {
                    Text("OK")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
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
    BlockedAppView()
}

