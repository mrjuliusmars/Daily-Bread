//
//  MoreTabView.swift
//  Daily Bread
//
//  More tab - settings and additional options
//

import SwiftUI

struct MoreTabView: View {
    @StateObject private var userSettings = UserSettings.shared
    @StateObject private var verseManager = DailyVerseManager.shared
    @State private var showChallengesEditor = false
    @State private var showGoalsEditor = false
    @State private var showBlockingTimeEditor = false
    @State private var showAppSelection = false
    @State private var showBibleVersionPicker = false
    @State private var isVisible = false
    @StateObject private var screenTimeManager = ScreenTimeManager()
    
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
                    Text("More")
                        .font(Font.custom("Lora-SemiBold", size: 32))
                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                        .tracking(-0.5)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                    
                    // Settings List
                    ScrollView {
                        VStack(spacing: 0) {
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showChallengesEditor = true
                            }) {
                                SimpleSettingsRow(
                                    title: "Your Challenges",
                                    icon: "exclamationmark.triangle.fill"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                            .padding(.top, 8)
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showGoalsEditor = true
                            }) {
                                SimpleSettingsRow(
                                    title: "Your Goals",
                                    icon: "target"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showBlockingTimeEditor = true
                            }) {
                                SimpleSettingsRow(
                                    title: "Blocking Time",
                                    icon: "clock.badge.checkmark"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showBibleVersionPicker = true
                            }) {
                                SimpleSettingsRow(
                                    title: "Bible Version",
                                    icon: "book.pages"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showAppSelection = true
                            }) {
                                SimpleSettingsRow(
                                    title: "Blocked Apps",
                                    icon: "lock.shield"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                        }
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 70, 90))
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showChallengesEditor) {
            ChallengesEditorView()
        }
        .fullScreenCover(isPresented: $showGoalsEditor) {
            GoalsEditorView()
        }
        .fullScreenCover(isPresented: $showBlockingTimeEditor) {
            BlockingTimeEditorView()
        }
        .sheet(isPresented: $showAppSelection) {
            AppSelectionView(isPresented: $showAppSelection)
                .environmentObject(screenTimeManager)
        }
        .fullScreenCover(isPresented: $showBibleVersionPicker) {
            BibleVersionPickerView()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
    }
    
}

// Simple Settings Row - Title only, no subtitle or description
struct SimpleSettingsRow: View {
    let title: String
    let icon: String
    
    private let textColor = Color(red: 1.0, green: 0.976, blue: 0.945)
    
    @ViewBuilder
    private var iconView: some View {
        switch title {
        case "Your Challenges":
            MountainIcon()
                .frame(width: 22, height: 16)
        case "Your Goals":
            Image(systemName: "target")
                .font(.system(size: 20, weight: .semibold))
        case "Blocking Time":
            Image(systemName: "clock")
                .font(.system(size: 20, weight: .semibold))
        case "Blocked Apps":
            Image(systemName: "lock")
                .font(.system(size: 20, weight: .semibold))
        case "Bible Version":
            DevotionalCross()
                .frame(width: 18, height: 18)
        default:
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
        }
    }
    
    var body: some View {
        HStack(spacing: 18) {
            iconView
                .foregroundColor(textColor)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 28, alignment: .leading)
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(textColor)
            
            Spacer(minLength: 0)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(textColor.opacity(0.55))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                )
        )
        .padding(.horizontal, 24)
        .padding(.top, 14)
    }
}

private struct DevotionalCross: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 1.0, green: 0.976, blue: 0.945))
                .frame(width: 3, height: 20)
                .cornerRadius(1.2)
            Rectangle()
                .fill(Color(red: 1.0, green: 0.976, blue: 0.945))
                .frame(width: 14, height: 3)
                .cornerRadius(1.2)
                .offset(y: -3)
        }
        .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: 1)
    }
}

private struct MountainIcon: View {
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 1, y: 15))
                path.addLine(to: CGPoint(x: 8, y: 4))
                path.addLine(to: CGPoint(x: 12, y: 9))
                path.addLine(to: CGPoint(x: 15, y: 5))
                path.addLine(to: CGPoint(x: 21, y: 15))
                path.addLine(to: CGPoint(x: 1, y: 15))
            }
            .fill(Color.white.opacity(0.12))
            
            Path { path in
                path.move(to: CGPoint(x: 1, y: 15))
                path.addLine(to: CGPoint(x: 8, y: 4))
                path.addLine(to: CGPoint(x: 12, y: 9))
                path.addLine(to: CGPoint(x: 15, y: 5))
                path.addLine(to: CGPoint(x: 21, y: 15))
            }
            .stroke(Color.white.opacity(0.7), lineWidth: 1.6)
        }
        .shadow(color: Color.black.opacity(0.18), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    MoreTabView()
}

