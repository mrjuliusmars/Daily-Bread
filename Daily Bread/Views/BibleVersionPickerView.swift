//
//  BibleVersionPickerView.swift
//  Daily Bread
//
//  Bible version selection with quiz question background
//

import SwiftUI

struct BibleVersionPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedBibleVersion") private var selectedBibleVersion: Int = 0
    @StateObject private var verseManager = DailyVerseManager.shared
    @State private var isVisible = false
    @State private var showOptions = false
    @State private var selectedTab: Tab = .more
    
    let bibleVersions = [
        "New International Version (NIV)",
        "English Standard Version (ESV)",
        "King James Version (KJV)",
        "New Living Translation (NLT)",
        "New King James Version (NKJV)",
        "Christian Standard Bible (CSB)"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let navHeight = 50 + max(geometry.safeAreaInsets.bottom, 16)
            let cutoff = navHeight + geometry.safeAreaInsets.bottom + 16
            let fadeHeight: CGFloat = 72
            ZStack(alignment: .bottom) {
                // Blurred background image from current verse - same as settings
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
                
                VStack(spacing: 0) {
                    // Top spacing
                    Spacer()
                        .frame(height: geometry.safeAreaInsets.top + 80)
                        .fixedSize()
                        .opacity(0)
                    
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
                            
                            Text("Bible Version")
                                .font(Font.custom("Lora-SemiBold", size: 24))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                .tracking(-0.5)
                            
                            Spacer()
                            
                            Spacer()
                                .frame(width: 44)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.4), value: isVisible)
                    
                    // Bible Version List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(bibleVersions.enumerated()), id: \.offset) { index, version in
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    selectedBibleVersion = index
                                }) {
                                    HStack(spacing: 16) {
                                        // Selection indicator
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    selectedBibleVersion == index ?
                                                    Color.white : Color.white.opacity(0.12)
                                                )
                                                .frame(width: 32, height: 32)
                                                .overlay(
                                                    Circle()
                                                        .stroke(
                                                            selectedBibleVersion == index ?
                                                            Color.white.opacity(0.6) : Color.white.opacity(0.25),
                                                            lineWidth: 1.8
                                                        )
                                                )
                                                .shadow(color: selectedBibleVersion == index ? Color.black.opacity(0.25) : Color.clear, radius: 6, x: 0, y: 2)
                                            
                                            if selectedBibleVersion == index {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(Color(red: 0.12, green: 0.18, blue: 0.24))
                                            }
                                        }
                                        
                                        // Version text
                                        Text(version)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                            .multilineTextAlignment(.leading)
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
                                .opacity(showOptions ? 1.0 : 0.0)
                                .offset(y: showOptions ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05), value: showOptions)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
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
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showOptions = true
                }
            }
        }
    }
}

#Preview {
    BibleVersionPickerView()
}

