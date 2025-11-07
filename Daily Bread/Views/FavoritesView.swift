//
//  FavoritesView.swift
//  Daily Bread
//
//  View to display favorite Bible verses
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @State private var isVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark mode grey gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.15, blue: 0.18),  // Dark grey top
                        Color(red: 0.12, green: 0.12, blue: 0.15),   // Darker grey middle
                        Color(red: 0.08, green: 0.08, blue: 0.1)    // Darkest grey bottom
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(12)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            Text("Favorites")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                            
                            Spacer()
                            
                            // Balance the layout
                            Spacer()
                                .frame(width: 44)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : -20)
                    .animation(.easeOut(duration: 0.4), value: isVisible)
                    
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
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.4).delay(0.2), value: isVisible)
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(favoritesManager.favoriteVerses) { verse in
                                    FavoriteVerseCard(verse: verse)
                                        .opacity(isVisible ? 1.0 : 0.0)
                                        .offset(y: isVisible ? 0 : 20)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(favoritesManager.favoriteVerses.firstIndex(where: { $0.id == verse.id }) ?? 0) * 0.05), value: isVisible)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                        }
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

struct FavoriteVerseCard: View {
    let verse: BibleVerse
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        Button(action: {
            // Could navigate to verse detail or BibleView
        }) {
            HStack(spacing: 16) {
                // Heart icon
                Image(systemName: "heart.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(verse.text)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(verse.reference.uppercased())
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                        .tracking(1)
                }
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavoritesView()
}

