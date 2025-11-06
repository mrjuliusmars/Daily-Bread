//
//  DevotionalView.swift
//  Daily Bread
//
//  Deeper dive into the verse with devotional content
//

import SwiftUI
import ManagedSettings

struct DevotionalView: View {
    let verse: BibleVerse
    @StateObject private var verseManager = DailyVerseManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var gradientOffset: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium animated gradient background (Dark Mode Grey)
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.15, blue: 0.18),  // Dark grey top
                        Color(red: 0.12, green: 0.12, blue: 0.15),   // Darker grey middle
                        Color(red: 0.08, green: 0.08, blue: 0.1)    // Darkest grey bottom
                    ],
                    startPoint: UnitPoint(x: 0.5 + gradientOffset * 0.1, y: 0),
                    endPoint: UnitPoint(x: 0.5 - gradientOffset * 0.1, y: 1)
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: gradientOffset)
                
                // Additional depth layer with royal blue accent
                RadialGradient(
                    colors: [
                        Color(red: 0.25, green: 0.5, blue: 0.85).opacity(0.4), // Lighter tint of royal blue
                        Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.25), // Exact royal blue
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.7 + gradientOffset * 0.05, y: 0.3),
                    startRadius: 50,
                    endRadius: 500
                )
                .ignoresSafeArea()
                .blendMode(.screen)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: gradientOffset)
                
                // Enhanced animated particles (royal blue - exact hue)
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.25, green: 0.5, blue: 0.85).opacity(0.35), // Lighter tint of royal blue
                                    Color(red: 0.15, green: 0.3, blue: 0.55).opacity(0.2), // Exact royal blue
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: CGFloat.random(in: 40...80))
                        .position(
                            x: Double((index % 5) * Int(geometry.size.width / 4)),
                            y: Double((index / 5) * Int(geometry.size.height / 4))
                        )
                        .opacity(0.6)
                        .blur(radius: 20)
                        .animation(
                            .easeInOut(duration: 8)
                            .repeatForever(autoreverses: false),
                            value: gradientOffset
                        )
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with verse reference
                        VStack(spacing: 16) {
                            Text(verse.reference)
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                .tracking(2)
                                .padding(.top, geometry.safeAreaInsets.top + 20)
                            
                            // Verse text (smaller, for reference)
                            Text(verse.text)
                                .font(.system(size: 18, weight: .medium, design: .serif))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.9))
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 32)
                                .padding(.top, 8)
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                        .animation(.easeOut(duration: 0.4), value: isVisible)
                        
                        // Devotional content
                        VStack(spacing: 24) {
                            // Divider
                            Rectangle()
                                .fill(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.2))
                                .frame(height: 1)
                                .padding(.horizontal, 32)
                                .padding(.top, 32)
                            
                            // Devotional text
                            VStack(alignment: .leading, spacing: 16) {
                                Text("For You Today")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                
                                Text(verse.devotional)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.9))
                                    .lineSpacing(6)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.2), value: isVisible)
                        
                        Spacer(minLength: 100) // Extra space for floating button
                    }
                }
                
                // Unlock Apps Button - Centered at Bottom
                VStack {
                    Spacer()
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        // Mark devotional as read (this will unlock apps)
                        verseManager.markDevotionalAsRead()
                        
                        // Success feedback
                        let successImpact = UINotificationFeedbackGenerator()
                        successImpact.notificationOccurred(.success)
                        
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Unlock Apps")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 1.0, green: 0.976, blue: 0.945))
                                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                        )
                        .padding(.horizontal, 32)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            gradientOffset = 0.3
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    DevotionalView(
        verse: BibleVerse(
            text: "For I, the Lord your God, will hold your right hand, saying to you, 'Don't be afraid. I will help you.'",
            reference: "ISAIAH 41:13",
            devotional: "When anxiety creeps in, remember that God is holding your hand. He's not distant or unaware—He's right beside you, ready to help. Take a deep breath and trust that His strength is greater than your worries.",
            backgroundImage: "b1",
            tags: ["anxiety", "stress"]
        )
    )
}

