//
//  ReadTabView.swift
//  Daily Bread
//
//  Read tab - Bible reading plan and history
//

import SwiftUI

struct ReadTabView: View {
    @State private var isVisible = false
    @StateObject private var verseManager = DailyVerseManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Blurred background image from current verse
                if let verse = verseManager.todaysVerse {
                    Image(verse.backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                        .blur(radius: 20)
                        .overlay(
                            // Gradient overlay to darken edges and prevent white artifacts
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.4), // Darker at top
                                    Color.black.opacity(0.3), // Middle
                                    Color.black.opacity(0.4)  // Darker at bottom
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    // Fallback gradient if no verse loaded
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.15, blue: 0.18),
                            Color(red: 0.12, green: 0.12, blue: 0.15),
                            Color(red: 0.08, green: 0.08, blue: 0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    // Status bar area
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.top)
                    
                    // Header
                    Text("Read")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                    
                    Spacer()
                    
                    // Placeholder content
                    VStack(spacing: 16) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5))
                        
                        Text("Your Reading Plan")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                        
                        Text("Track your daily Bible reading and history")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    
                    Spacer()
                    
                    // Bottom padding for tab bar
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: max(geometry.safeAreaInsets.bottom + 70, 90))
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ReadTabView()
}

