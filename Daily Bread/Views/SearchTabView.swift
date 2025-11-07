//
//  SearchTabView.swift
//  Daily Bread
//
//  Search tab - search for Bible verses
//

import SwiftUI

struct SearchTabView: View {
    @State private var searchText = ""
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
                    Text("Search")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black.opacity(0.6))
                        
                        TextField("Search verses...", text: $searchText)
                            .foregroundColor(.black)
                            .tint(.black)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black.opacity(0.6))
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                            )
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : -10)
                    
                    Spacer()
                    
                    // Placeholder content
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5))
                        
                        Text("Search for Bible Verses")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                        
                        Text("Find verses by keyword, topic, or reference")
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
    SearchTabView()
}

