//
//  BibleView.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI
import ManagedSettings
import UIKit
import AudioToolbox

struct BibleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showFlash = false
    @State private var verseOpacity: Double = 1.0
    var onComplete: (() -> Void)?
    
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
                            .opacity(verseOpacity)
                        
                        // Verse reference - sans-serif font
                        Text("ISAIAH 41:13")
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .tracking(1)
                            .opacity(verseOpacity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, geometry.safeAreaInsets.top + (geometry.size.height - geometry.safeAreaInsets.top) * 0.08)
                    
                    Spacer()
                    
                    // "Done Reading" button at bottom - Glassmorphism style
                    Button(action: {
                        handleDoneReading()
                    }) {
                        Text("Done Reading")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                ZStack {
                                    // Glassmorphism effect - semi-transparent white with blur
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            Capsule()
                                                .fill(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.white.opacity(0.25),
                                                            Color.white.opacity(0.15)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                        )
                                        .overlay(
                                            Capsule()
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color.white.opacity(0.4),
                                                            Color.white.opacity(0.2)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1.5
                                                )
                                        )
                                }
                            )
                            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 32)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 24, 40))
                }
                
                // Fade-to-white flash overlay
                if showFlash {
                    Rectangle()
                        .fill(Color.white)
                        .ignoresSafeArea()
                        .opacity(showFlash ? 1.0 : 0.0)
                        .transition(.opacity)
                }
            }
        }
    }
    
    private func handleDoneReading() {
        // Haptic feedback - soft chime vibration
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
        
        // Play subtle system sound (subtle chime)
        AudioServicesPlaySystemSound(1057) // System sound ID for subtle chime
        
        // Start animation sequence
        withAnimation(.easeOut(duration: 0.3)) {
            // Fade out verse
            verseOpacity = 0.0
        }
        
        // Then fade to white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeIn(duration: 0.5)) {
                showFlash = true
            }
            
            // Unblock apps after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let store = ManagedSettingsStore(named: .main)
                store.clearAllSettings()
                
                print("✅ Apps unblocked - user has read their verse")
                
                // Mark verse as read for streak tracking
                let streakTracker = StreakTracker()
                let newStreak = streakTracker.markVerseRead()
                print("🔥 Streak: \(newStreak) Days Putting God First")
                
                // Navigate to ContentView after unlocking
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // Dismiss BibleView to return to ContentView
                    if let onComplete = onComplete {
                        onComplete()
                    } else {
                        dismiss()
                    }
                    
                    // Also post notification for other listeners
                    NotificationCenter.default.post(name: Notification.Name("VerseReadAndUnlocked"), object: nil)
                }
            }
        }
    }
}

#Preview {
    BibleView()
}

