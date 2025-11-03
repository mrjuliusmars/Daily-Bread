//
//  BibleView.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI

struct BibleView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("b1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                VStack {
                    // Main content area - Bible verse positioned at top third
                    VStack(spacing: 24) {
                        // Bible verse text - serif font
                        Text("For I, the Lord your\nGod, will hold your\nright hand, saying to\nyou, 'Don't be afraid.\nI will help you'")
                            .font(.system(size: 32, weight: .semibold, design: .serif))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding(.horizontal, 32)
                        
                        // Verse reference - sans-serif font
                        Text("ISAIAH 41:13")
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .tracking(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, geometry.safeAreaInsets.top + (geometry.size.height - geometry.safeAreaInsets.top) * 0.08)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    BibleView()
}

