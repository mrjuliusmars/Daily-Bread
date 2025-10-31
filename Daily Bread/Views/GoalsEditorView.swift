//
//  GoalsEditorView.swift
//  Daily Bread
//
//  Detail view for editing goals
//

import SwiftUI
import UIKit

struct GoalsEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userSettings = UserSettings.shared
    @State private var selectedGoals: Set<Int> = []
    @State private var isVisible = false
    
    private let question5 = quizQuestions.first(where: { $0.id == 5 })!
    
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
                
                ScrollView {
                    VStack(spacing: 0) {
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
                                
                                Text("Goals")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                
                                Spacer()
                                
                                // Balance the layout
                                Spacer()
                                    .frame(width: 44)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                            
                            Text("Your goals determine which Bible verses you'll receive to support your spiritual journey")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .padding(.top, 8)
                                .lineSpacing(2)
                            
                            if let subtitle = question5.subtitle {
                                Text(subtitle)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.6))
                                    .padding(.horizontal, 24)
                                    .padding(.top, 4)
                            }
                        }
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : -20)
                        .animation(.easeOut(duration: 0.4), value: isVisible)
                        
                        // Options List
                        VStack(spacing: 12) {
                            ForEach(Array(question5.options.enumerated()), id: \.offset) { index, option in
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    
                                    if selectedGoals.contains(index) {
                                        selectedGoals.remove(index)
                                    } else {
                                        selectedGoals.insert(index)
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    selectedGoals.contains(index) ?
                                                    Color(red: 1.0, green: 0.976, blue: 0.945) :
                                                    Color.white.opacity(0.1)
                                                )
                                                .frame(width: 32, height: 32)
                                                .overlay(
                                                    Circle()
                                                        .stroke(
                                                            selectedGoals.contains(index) ?
                                                        Color(red: 1.0, green: 0.976, blue: 0.945) :
                                                        Color.white.opacity(0.3),
                                                            lineWidth: 2
                                                        )
                                                )
                                            
                                            Image(systemName: selectedGoals.contains(index) ? "checkmark" : "")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.black)
                                        }
                                        
                                        Text(option)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                selectedGoals.contains(index) ?
                                                Color.white.opacity(0.08) :
                                                Color.white.opacity(0.03)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(
                                                        selectedGoals.contains(index) ?
                                                        Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.4) :
                                                        Color.white.opacity(0.1),
                                                        lineWidth: 1.5
                                                    )
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
                        .padding(.top, 32)
                        
                        // Save Button
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            // Update user settings
                            userSettings.selectedGoals = selectedGoals
                            userSettings.saveSettings()
                            
                            // Update Bible verses based on new selections
                            updateBibleVerses()
                            
                            // Show success feedback
                            let successImpact = UINotificationFeedbackGenerator()
                            successImpact.notificationOccurred(.success)
                            
                            dismiss()
                        }) {
                            Text("Save")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color(red: 1.0, green: 0.976, blue: 0.945))
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40))
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isVisible)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Load current settings
            selectedGoals = userSettings.selectedGoals
            
            // Animate in
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
    }
    
    private func updateBibleVerses() {
        // TODO: Implement Bible verse update logic based on challenges and goals
        // This would fetch/recalculate Bible verses based on the user's updated challenges and goals
        print("📖 Updating Bible verses based on:")
        print("   Challenges: \(userSettings.getChallengeNames())")
        print("   Goals: \(userSettings.getGoalNames())")
        
        // Save to UserDefaults for later use in verse selection
        UserDefaults.standard.set(userSettings.getChallengeNames(), forKey: "currentChallenges")
        UserDefaults.standard.set(userSettings.getGoalNames(), forKey: "currentGoals")
        UserDefaults.standard.synchronize()
    }
}

#Preview {
    GoalsEditorView()
}

