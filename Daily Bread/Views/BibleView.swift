//
//  BibleView.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI
import UIKit

struct BibleView: View {
    @StateObject private var verseManager = DailyVerseManager.shared
    @State private var showDevotional = false
    @State private var showMenu = false
    @State private var showVerse = false
    @State private var showReference = false
    @State private var showCrossButton = false
    @State private var showBottomNav = false
    @State private var showFavorites = false
    @State private var showSettings = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let verse = verseManager.todaysVerse {
                // Background image
                    Image(verse.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                VStack {
                    // Main content area - Bible verse positioned at top third
                    VStack(spacing: 24) {
                            // Bible verse text - Lora, 30pt, optimal line length, soft ivory
                            Text(verse.text)
                                .font(loraFont(size: 30, weight: .regular))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // #FFF9F1 soft ivory
                            .multilineTextAlignment(.center)
                                .lineSpacing(2) // Reduced spacing for tighter lines
                                .frame(maxWidth: min(geometry.size.width * 0.75, 320)) // Optimal line length: 75% of screen or 320pt max
                            .padding(.horizontal, 32)
                                .opacity(showVerse ? 1.0 : 0.0)
                                .offset(y: showVerse ? 0 : 10)
                                .animation(.easeInOut(duration: 2.5), value: showVerse)
                            
                            // Verse reference - DM Sans, uppercase, +200 tracking
                            Text(verse.reference.uppercased())
                                .font(dmSansFont(size: 14, weight: .regular))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // #FFF9F1 soft ivory
                                .tracking(2.0) // +200 tracking (2.0 points)
                                .opacity(showReference ? 1.0 : 0.0)
                                .offset(y: showReference ? 0 : -10)
                                .animation(.easeInOut(duration: 2.5), value: showReference)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, geometry.safeAreaInsets.top + (geometry.size.height - geometry.safeAreaInsets.top) * 0.08)
                    
                    Spacer()
                    
                    // Bottom navigation bar (separate bar at absolute bottom with 5 icons)
                    if showBottomNav {
                        BottomNavigationBar(
                            showFavorites: $showFavorites,
                            showSettings: $showSettings,
                            onDismiss: { dismiss() }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .overlay(alignment: .bottom) {
                    // Cross button - centered, floating above navigation bar (NEVER MOVES - fixed position using overlay)
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        verseManager.markVerseAsRead()
                        showMenu = true
                    }) {
                        ZStack {
                            // Frosted glass background - more transparent
                            Circle()
                                .fill(.ultraThinMaterial.opacity(0.6))
                                .frame(width: 72, height: 72)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.4),
                                                    Color.white.opacity(0.15)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                .shadow(color: Color.white.opacity(0.05), radius: 2, x: 0, y: -2)
                            
                            // Icon
                            Image("pngicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 52, height: 52)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity((showCrossButton && !showMenu) ? 1.0 : 0.0)
                    .scaleEffect((showCrossButton && !showMenu) ? 1.0 : 0.8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showMenu)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showCrossButton)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                    .allowsHitTesting(showCrossButton && !showMenu)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // Toggle bottom nav on tap (but not when menu is open)
                    if !showMenu {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showBottomNav.toggle()
                        }
                    }
                }
                .onChange(of: showMenu) { newValue in
                    // Hide bottom nav when menu opens
                    if newValue && showBottomNav {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showBottomNav = false
                        }
                    }
                }
                } else {
                    // Loading state
                    ProgressView()
                        .tint(.white)
                }
            }
        }
        .navigationBarHidden(true)
        .overlay {
            if showMenu, let verse = verseManager.todaysVerse {
                BibleVerseMenuView(verse: verse, showDevotional: $showDevotional, isPresented: $showMenu)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showMenu)
        .fullScreenCover(isPresented: $showDevotional) {
            if let verse = verseManager.todaysVerse {
                DevotionalView(verse: verse)
            }
        }
        .sheet(isPresented: $showFavorites) {
            FavoritesView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            verseManager.loadTodaysVerse()
            
            // Fade in verse immediately
            withAnimation {
                showVerse = true
            }
            
            // Show reference after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showReference = true
            }
            
            // Show cross button after reference animation completes (2 seconds delay + 2.5 seconds animation = 4.5 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                showCrossButton = true
            }
        }
    }
}

// Helper function to load Lora font with fallback
private func loraFont(size: CGFloat, weight: Font.Weight) -> Font {
    // First, try to get all fonts in the Lora family
    let loraFamilyFonts = UIFont.fontNames(forFamilyName: "Lora")
    
    // If we found Lora fonts, use them
    if !loraFamilyFonts.isEmpty {
        let fontName: String?
        
        switch weight {
        case .bold:
            fontName = loraFamilyFonts.first { $0.contains("Bold") && !$0.contains("Italic") } ?? loraFamilyFonts.first { $0.contains("Bold") }
        case .semibold:
            fontName = loraFamilyFonts.first { $0.contains("Semibold") || $0.contains("Semi") || $0.contains("Medium") }
        case .medium:
            fontName = loraFamilyFonts.first { $0.contains("Medium") }
        case .light:
            fontName = loraFamilyFonts.first { $0.contains("Light") && !$0.contains("Italic") } ?? loraFamilyFonts.first { $0.contains("Light") }
        default:
            fontName = loraFamilyFonts.first { $0.contains("Regular") } ?? loraFamilyFonts.first { !$0.contains("Italic") && !$0.contains("Bold") && !$0.contains("Light") && !$0.contains("Black") && !$0.contains("Thin") }
        }
        
        if let fontName = fontName, let font = UIFont(name: fontName, size: size) {
            #if DEBUG
            print("✅ Using Lora font: \(fontName) at size \(size)")
            #endif
            return Font(font)
        }
    }
    
    // Fallback: Try common Lora font name variations
    let fontNames: [String]
    
    switch weight {
    case .bold:
        fontNames = ["Lora-Bold", "Lora Bold", "LoraBold", "Lora"]
    case .semibold:
        fontNames = ["Lora-SemiBold", "Lora SemiBold", "LoraSemiBold", "Lora-Medium", "Lora"]
    case .medium:
        fontNames = ["Lora-Medium", "Lora Medium", "LoraMedium", "Lora"]
    case .light:
        fontNames = ["Lora-Light", "Lora Light", "LoraLight", "Lora"]
    default:
        fontNames = ["Lora-Regular", "Lora Regular", "LoraRegular", "Lora"]
    }
    
    // Try to find the font
    for fontName in fontNames {
        if let font = UIFont(name: fontName, size: size) {
            #if DEBUG
            print("✅ Using Lora font (by name): \(fontName) at size \(size)")
            #endif
            return Font(font)
        }
    }
    
    // Fallback to system serif font (similar elegant serif)
    #if DEBUG
    print("⚠️ Lora not found, using system serif font at size \(size)")
    #endif
    return .system(size: size, weight: weight, design: .serif)
}

// Helper function to load DM Sans font with fallback
private func dmSansFont(size: CGFloat, weight: Font.Weight) -> Font {
    // First, try to get all fonts in the DM Sans family
    let dmSansFamilyFonts = UIFont.fontNames(forFamilyName: "DM Sans")
    
    // If we found DM Sans fonts, use them
    if !dmSansFamilyFonts.isEmpty {
        let fontName: String?
        
        switch weight {
        case .bold:
            fontName = dmSansFamilyFonts.first { $0.contains("Bold") && !$0.contains("Italic") } ?? dmSansFamilyFonts.first { $0.contains("Bold") }
        case .semibold:
            fontName = dmSansFamilyFonts.first { $0.contains("Semibold") || $0.contains("Semi") || $0.contains("Medium") }
        case .medium:
            fontName = dmSansFamilyFonts.first { $0.contains("Medium") }
        case .light:
            fontName = dmSansFamilyFonts.first { $0.contains("Light") && !$0.contains("Italic") } ?? dmSansFamilyFonts.first { $0.contains("Light") }
        default:
            fontName = dmSansFamilyFonts.first { $0.contains("Regular") } ?? dmSansFamilyFonts.first { !$0.contains("Italic") && !$0.contains("Bold") && !$0.contains("Light") && !$0.contains("Black") && !$0.contains("Thin") }
        }
        
        if let fontName = fontName, let font = UIFont(name: fontName, size: size) {
            #if DEBUG
            print("✅ Using DM Sans font: \(fontName) at size \(size)")
            #endif
            return Font(font)
        }
    }
    
    // Fallback: Try common DM Sans font name variations
    let fontNames: [String]
    
    switch weight {
    case .bold:
        fontNames = ["DMSans-Bold", "DM Sans Bold", "DMSansBold", "DMSans"]
    case .semibold:
        fontNames = ["DMSans-SemiBold", "DM Sans SemiBold", "DMSansSemiBold", "DMSans-Medium", "DMSans"]
    case .medium:
        fontNames = ["DMSans-Medium", "DM Sans Medium", "DMSansMedium", "DMSans"]
    case .light:
        fontNames = ["DMSans-Light", "DM Sans Light", "DMSansLight", "DMSans"]
    default:
        fontNames = ["DMSans-Regular", "DM Sans Regular", "DMSansRegular", "DMSans"]
    }
    
    // Try to find the font
    for fontName in fontNames {
        if let font = UIFont(name: fontName, size: size) {
            #if DEBUG
            print("✅ Using DM Sans font (by name): \(fontName) at size \(size)")
            #endif
            return Font(font)
        }
    }
    
    // Fallback to system font (clean, modern sans-serif similar to DM Sans)
    #if DEBUG
    print("⚠️ DM Sans not found, using system font at size \(size)")
    #endif
    return .system(size: size, weight: weight, design: .default)
}

// Bottom Navigation Bar Component
struct BottomNavigationBar: View {
    @Binding var showFavorites: Bool
    @Binding var showSettings: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            // Navigation bar with 5 icons evenly spaced
            HStack(spacing: 0) {
                // Home
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    onDismiss()
                }) {
                    Image(systemName: "house")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                
                // Search
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    // TODO: Implement search
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                
                // Book (Bible)
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    // Already on BibleView, do nothing or refresh
                }) {
                    Image(systemName: "book")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                
                // Favorites (Heart)
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    showFavorites = true
                }) {
                    Image(systemName: "heart")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                
                // Settings (3 dots)
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    showSettings = true
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                // Transparent - let background show through
                Rectangle()
                    .fill(Color.clear)
            )
            .padding(.bottom, 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    BibleView()
}

