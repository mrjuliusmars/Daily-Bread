//
//  SettingsView.swift
//  Daily Bread
//
//  Settings screen with list-style interface
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userSettings = UserSettings.shared
    @State private var showChallengesEditor = false
    @State private var showGoalsEditor = false
    @State private var showBlockingTimeEditor = false
    @State private var isVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Royal blue gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.3, blue: 0.55),
                        Color(red: 0.1, green: 0.2, blue: 0.45),
                        Color(red: 0.05, green: 0.1, blue: 0.35)
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
                            
                            Text("Settings")
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
                    
                    // Settings List
                    ScrollView {
                        VStack(spacing: 0) {
                            // Info Banner
                            HStack(spacing: 12) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Personalize Your Daily Verses")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                    
                                    Text("Your challenges and goals determine which Bible verses you'll receive each day")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.4), lineWidth: 1.5)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.05), value: isVisible)
                            
                            // Challenges Row
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showChallengesEditor = true
                            }) {
                                SettingsRow(
                                    title: "Challenges",
                                    subtitle: getChallengesSubtitle(),
                                    description: "Verses to help with your struggles",
                                    icon: "exclamationmark.triangle.fill",
                                    iconColor: Color(red: 1.0, green: 0.976, blue: 0.945)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15), value: isVisible)
                            
                            // Goals Row
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showGoalsEditor = true
                            }) {
                                SettingsRow(
                                    title: "Goals",
                                    subtitle: getGoalsSubtitle(),
                                    description: "Verses to support your spiritual journey",
                                    icon: "target",
                                    iconColor: Color(red: 1.0, green: 0.976, blue: 0.945)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.25), value: isVisible)
                            
                            // Blocking Time Row
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                showBlockingTimeEditor = true
                            }) {
                                SettingsRow(
                                    title: "Blocking Time",
                                    subtitle: getBlockingTimeSubtitle(),
                                    description: "When apps are blocked each day",
                                    icon: "clock.fill",
                                    iconColor: Color(red: 1.0, green: 0.976, blue: 0.945)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.35), value: isVisible)
                        }
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showChallengesEditor) {
            ChallengesEditorView()
        }
        .sheet(isPresented: $showGoalsEditor) {
            GoalsEditorView()
        }
        .sheet(isPresented: $showBlockingTimeEditor) {
            BlockingTimeEditorView()
        }
        .onAppear {
            // Animate in
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
    }
    
    private func getChallengesSubtitle() -> String {
        let challenges = userSettings.getChallengeNames()
        if challenges.isEmpty {
            return "Tap to add challenges"
        } else if challenges.count == 1 {
            return challenges[0]
        } else {
            return "\(challenges.count) selected"
        }
    }
    
    private func getGoalsSubtitle() -> String {
        let goals = userSettings.getGoalNames()
        if goals.isEmpty {
            return "Tap to add goals"
        } else if goals.count == 1 {
            return goals[0]
        } else {
            return "\(goals.count) selected"
        }
    }
    
    private func getBlockingTimeSubtitle() -> String {
        let hour = UserDefaults.standard.object(forKey: "blockingHour") as? Int ?? 14
        let minute = UserDefaults.standard.object(forKey: "blockingMinute") as? Int ?? 37
        let hour12 = hour % 12 == 0 ? 12 : hour % 12
        let amPm = hour < 12 ? "AM" : "PM"
        return String(format: "%d:%02d %@", hour12, minute, amPm)
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let description: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(iconColor.opacity(0.4), lineWidth: 1.5)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.7))
                    .lineLimit(1)
                
                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.8))
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                )
        )
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}

#Preview {
    SettingsView()
}
