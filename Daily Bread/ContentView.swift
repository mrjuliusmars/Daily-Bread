//
//  ContentView.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var hasReadToday = false
    @State private var showAppSelection = false
    @StateObject private var screenTimeManager = ScreenTimeManager()
    
    var body: some View {
        GeometryReader { geometry in
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
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Status bar area (top safe area)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.top)
                    
                    // Top navigation buttons
                    HStack {
                        // Bible/Cross button (top left)
                        Button(action: {}) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.05, green: 0.1, blue: 0.35))
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "book.closed.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                        
                        // Settings button (top right)
                        Button(action: {}) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.05, green: 0.1, blue: 0.35))
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    // Main content area - Praying hands
                    VStack(spacing: 20) {
                        // Praying hands icon with sparkles
                        ZStack {
                            Image(systemName: "hand.raised.fill")
                                .font(.system(size: 120))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                            
                            // Sparkles around the hands
                            ForEach(0..<3) { index in
                                Image(systemName: "sparkle")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                                    .offset(
                                        x: CGFloat(index - 1) * 50,
                                        y: index == 0 ? -30 : 30
                                    )
                            }
                        }
                        
                        Text("Your bible verse will appear here")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Bottom button - Apps You Blocked
                    Button(action: {
                        showAppSelection = true
                    }) {
                        HStack(spacing: 12) {
                            Text("Apps You Blocked")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            
                            Text("🙏")
                                .font(.system(size: 20))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.05, green: 0.1, blue: 0.35))
                        )
                        .padding(.horizontal, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAppSelection) {
            AppSelectionView(isPresented: $showAppSelection)
                .environmentObject(screenTimeManager)
        }
    }
}

#Preview {
    ContentView()
}
