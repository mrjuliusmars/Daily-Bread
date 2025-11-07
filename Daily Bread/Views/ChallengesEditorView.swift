//
//  ChallengesEditorView.swift
//  Daily Bread
//
//  Detail view for editing challenges
//

import SwiftUI
import UIKit

struct ChallengesEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userSettings = UserSettings.shared
    @StateObject private var verseManager = DailyVerseManager.shared
    @State private var selectedChallenges: Set<Int> = []
    @State private var isVisible = false
    @State private var selectedTab: Tab = .more
    
    private let question7 = quizQuestions.first(where: { $0.id == 7 })!
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Blurred background image from current verse
                if let verse = verseManager.todaysVerse {
                    Image(verse.backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .scaleEffect(1.1)
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
                
                let navHeight = 50 + max(geometry.safeAreaInsets.bottom, 16)
                let cutoff = navHeight + geometry.safeAreaInsets.bottom + 16
                let fadeHeight: CGFloat = 72
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: geometry.safeAreaInsets.top + 80)
                            .fixedSize()
                            .opacity(0)
                        
                        // Header
                        VStack(spacing: 16) {
                            HStack {
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    dismiss()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(12)
                                        .background(Color.white.opacity(0.1))
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                Text("Your Challenges")
                                    .font(Font.custom("Lora-SemiBold", size: 24))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                    .tracking(-0.5)
                                
                                Spacer()
                                
                                // Balance the layout
                                Spacer()
                                    .frame(width: 44)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 8)
                            
                            Text("Your challenges determine which Bible verses you'll receive to help with your struggles")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .padding(.top, 8)
                                .lineSpacing(2)
                            
                            if let subtitle = question7.subtitle {
                                Text(subtitle)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.6))
                                    .padding(.horizontal, 24)
                                    .padding(.top, 4)
                                    .hidden()
                            }
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                        .animation(.easeOut(duration: 0.4), value: isVisible)
                        
                        // Options List
                        VStack(spacing: 10) {
                            ForEach(Array(question7.options.enumerated()), id: \.offset) { index, option in
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    
                                    if selectedChallenges.contains(index) {
                                        selectedChallenges.remove(index)
                                    } else {
                                        selectedChallenges.insert(index)
                                    }
                                    
                                    userSettings.selectedChallenges = selectedChallenges
                                    userSettings.saveSettings()
                                }) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    selectedChallenges.contains(index) ?
                                                    Color.white : Color.white.opacity(0.12)
                                                )
                                                .frame(width: 32, height: 32)
                                                .overlay(
                                                    Circle()
                                                        .stroke(
                                                            selectedChallenges.contains(index) ?
                                                            Color.white.opacity(0.6) : Color.white.opacity(0.25),
                                                            lineWidth: 1.8
                                                        )
                                                )
                                                .shadow(color: selectedChallenges.contains(index) ? Color.black.opacity(0.25) : Color.clear, radius: 6, x: 0, y: 2)
                                            
                                            if selectedChallenges.contains(index) {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(Color(red: 0.12, green: 0.18, blue: 0.24))
                                            }
                                        }
                                        
                                        Text(option)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.9)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.trailing, 8)
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color.white.opacity(0.08))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 18)
                                                    .stroke(Color.white.opacity(0.25), lineWidth: 1.2)
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05), value: isVisible)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, navHeight + 20)
                    }
                }
                .scrollContentBackground(.hidden)
                .mask(
                    Rectangle()
                        .padding(.bottom, cutoff)
                )
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.24)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: fadeHeight)
                    .allowsHitTesting(false)
                }
                
                // Bottom navigation bar - always visible
                BottomTabBar(selectedTab: $selectedTab, onTabChange: { newTab in
                    if newTab != .more {
                        dismiss()
                        // Post notification to switch tabs after dismissal
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            NotificationCenter.default.post(name: NSNotification.Name("SwitchTab"), object: nil, userInfo: ["tab": newTab.rawValue])
                        }
                    }
                })
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
        .onAppear {
            // Load current settings
            selectedChallenges = userSettings.selectedChallenges
            
            // Animate in
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ChallengesEditorView()
}

