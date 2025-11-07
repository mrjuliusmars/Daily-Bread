//
//  FavoritesTabView.swift
//  Daily Bread
//
//  Favorites tab - wrapper for FavoritesView with bottom nav
//

import SwiftUI

struct FavoritesTabView: View {
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var verseManager = DailyVerseManager.shared
    @State private var isVisible = false
    
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
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                VStack(spacing: 0) {
                    // Top spacing
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.top + 80)
                    
                    // Header
                    Text("Favorites")
                        .font(Font.custom("Lora-SemiBold", size: 32))
                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                        .tracking(-0.5)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                    
                    // Favorites List
                    if favoritesManager.favoriteVerses.isEmpty {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "heart")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5))
                            
                            Text("No Favorites Yet")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            
                            Text("Tap the heart icon on any verse\nto add it to your favorites")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.7))
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            // Bottom padding for tab bar
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: max(geometry.safeAreaInsets.bottom + 70, 90))
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(favoritesManager.favoriteVerses) { verse in
                                    FavoriteVerseCard(verse: verse)
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .offset(y: isVisible ? 0 : 20)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, max(geometry.safeAreaInsets.bottom + 70, 90))
                        }
                        .scrollContentBackground(.hidden)
                    }
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
    FavoritesTabView()
}

