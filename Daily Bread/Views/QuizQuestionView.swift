import SwiftUI
import UIKit

struct QuizQuestionView: View {
    let questionNumber: Int
    @EnvironmentObject var onboardingState: OnboardingState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOptions: Set<Int> = [] // Changed to support multiple selections
    @State private var isVisible = false
    @State private var showContent = false
    @State private var showOptions = false
    
    private var question: QuizQuestion {
        quizQuestions[questionNumber - 1]
    }
    
    private var progress: CGFloat {
        let totalQuestions = quizQuestions.count
        return CGFloat(questionNumber) / CGFloat(totalQuestions)
    }
    
    // Safe access to current question's answers
    private var currentAnswers: Set<Int> {
        Set(onboardingState.quizAnswers[questionNumber] ?? [])
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Royal blue gradient background to match carousel
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.3, blue: 0.55),  // Royal blue top
                        Color(red: 0.1, green: 0.2, blue: 0.45),   // Deeper royal blue
                        Color(red: 0.05, green: 0.1, blue: 0.35)   // Dark royal blue bottom
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Subtle floating particles (cream/ivory like carousel)
                ForEach(0..<12, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 255/255, green: 250/255, blue: 205/255).opacity(0.15), // Cream/ivory
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: CGFloat.random(in: 40...70))
                        .position(
                            x: Double((index % 5) * Int(geometry.size.width / 4)),
                            y: Double((index / 5) * Int(geometry.size.height / 4))
                        )
                        .opacity(0.5)
                        .blur(radius: 15)
                }
                
                VStack(spacing: 0) {
                    // Top branding (fixed)
                    VStack(spacing: 8) {
                        HStack {
                            // Back button - only show if not question 1
                            if questionNumber > 1 {
                                Button(action: {
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                    
                                    // Go to previous question
                                    onboardingState.navigateTo(.quiz(questionNumber - 1))
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(12)
                                }
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.5).delay(0.1), value: isVisible)
                            } else {
                                // Empty space to maintain layout when back button is hidden
                                Spacer()
                                    .frame(width: 42) // Match the back button width
                            }
                            
                            Spacer()
                            
                            if let logoImage = UIImage(named: "ivorylogo") {
                                Image(uiImage: logoImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .animation(.easeOut(duration: 0.5), value: isVisible)
                            } else {
                                Text("Daily Bread")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .animation(.easeOut(duration: 0.5), value: isVisible)
                            }
                            
                            Spacer()
                            
                            // Empty space on right to balance layout
                            Spacer()
                                .frame(width: 42) // Match the left side spacing
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, -25)
                        
                        // Progress section
                        VStack(spacing: 4) {
                            HStack {
                                Text("Question \(questionNumber) of \(quizQuestions.count)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.7)) // Ivory White #FFF9F1
                                Spacer()
                            }
                            
                            GeometryReader { progressGeometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 4)
                                        .cornerRadius(2)
                                    
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.white, Color.white.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: progressGeometry.size.width * progress, height: 4)
                                        .cornerRadius(2)
                                        .animation(.easeOut(duration: 0.5), value: progress)
                                }
                            }
                            .frame(height: 4)
                        }
                        .padding(.horizontal, 24)
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: isVisible)
                    
                    // Question title (fixed at top for multi-select questions 4, 5, 7, 8)
                    if questionNumber == 4 || questionNumber == 5 || questionNumber == 7 || questionNumber == 8 {
                        VStack(spacing: 16) {
                            Text(question.question)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                .multilineTextAlignment(.center)
                                .lineLimit(4)
                                .minimumScaleFactor(0.7)
                                .lineSpacing(6)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                .opacity(showContent ? 1.0 : 0.0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                                .padding(.horizontal, 24)
                                .padding(.top, 8)
                                .padding(.bottom, 24)
                        }
                    }
                    
                    // Content area - different layout for multi-select questions (4, 5, 7, 8) vs single-select
                    if questionNumber == 4 || questionNumber == 5 || questionNumber == 7 || questionNumber == 8 {
                        // Scrollable options only for questions 4 and 5 (title is fixed above)
                        ScrollView {
                            VStack(spacing: 10) {
                                // Extra spacing at top to separate from question
                                Spacer()
                                    .frame(height: 8)
                                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                                    Button(action: {
                                        // Haptic feedback
                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                        
                                        if question.allowsMultipleSelection {
                                            // Toggle selection for multi-select questions
                                            if selectedOptions.contains(index) {
                                                selectedOptions.remove(index)
                                            } else {
                                                selectedOptions.insert(index)
                                            }
                                            onboardingState.quizAnswers[questionNumber] = Array(selectedOptions)
                                        } else {
                                            // Single selection for regular questions
                                            selectedOptions = [index]
                                            onboardingState.quizAnswers[questionNumber] = [index]
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                if questionNumber == quizQuestions.count {
                                                    onboardingState.navigateTo(.userInfo)
                                                } else {
                                                    onboardingState.navigateTo(.quiz(questionNumber + 1))
                                                }
                                            }
                                        }
                                    }) {
                                        HStack(spacing: 12) {
                                            // Clean circular indicator with checkmark or number
                                            ZStack {
                                                Circle()
                                                    .fill(
                                                        selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                        Color(red: 1.0, green: 0.976, blue: 0.945) : Color.white.opacity(0.1) // Gold for selected
                                                    )
                                                    .frame(width: 32, height: 32)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(
                                                                selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                                Color(red: 1.0, green: 0.976, blue: 0.945) : Color.white.opacity(0.3), // Gold for selected
                                                                lineWidth: 2
                                                            )
                                                    )
                                                
                                                if question.allowsMultipleSelection {
                                                    // Show checkmark for multi-select questions
                                                    Image(systemName: selectedOptions.contains(index) || currentAnswers.contains(index) ? "checkmark" : "")
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(.black)
                                                } else {
                                                    // Show number for single-select questions
                                                    Text("\(index + 1)")
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(
                                                            selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                            .black : Color(red: 1.0, green: 0.976, blue: 0.945) // Ivory White #FFF9F1
                                                        )
                                                }
                                            }
                                            
                                            // Option text
                                            Text(option)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // Ivory White #FFF9F1
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                    Color.white.opacity(0.08) : Color.white.opacity(0.03)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(
                                                            selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                            Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.4) : Color.white.opacity(0.1), // Gold border for selected
                                                            lineWidth: 1.5
                                                        )
                                                )
                                        )
                                    }
                                    .scaleEffect(selectedOptions.contains(index) || currentAnswers.contains(index) ? 1.02 : 1.0)
                                    .opacity(showOptions ? 1.0 : 0.0)
                                    .offset(y: showOptions ? 0 : 20)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.08), value: showOptions)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedOptions)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                            .padding(.bottom, 100) // Extra padding for sticky button
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make ScrollView fill available space
                    } else {
                        // Scrollable content for questions 1-3 (question title + options together)
                        ScrollView {
                            VStack(spacing: 16) {
                                // Question title
                                Text(question.question)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(4)
                                    .minimumScaleFactor(0.7)
                                    .lineSpacing(6)
                                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                    .opacity(showContent ? 1.0 : 0.0)
                                    .offset(y: showContent ? 0 : 20)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 8)
                                    .padding(.bottom, 24)
                                
                                // Options
                                VStack(spacing: 14) {
                                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                                        Button(action: {
                                            let impact = UIImpactFeedbackGenerator(style: .medium)
                                            impact.impactOccurred()
                                            
                                            if question.allowsMultipleSelection {
                                                // Toggle selection for multi-select questions
                                                if selectedOptions.contains(index) {
                                                    selectedOptions.remove(index)
                                                } else {
                                                    selectedOptions.insert(index)
                                                }
                                                onboardingState.quizAnswers[questionNumber] = Array(selectedOptions)
                                            } else {
                                                // Single selection for regular questions
                                                selectedOptions = [index]
                                                onboardingState.quizAnswers[questionNumber] = [index]
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    if questionNumber == quizQuestions.count {
                                                        onboardingState.navigateTo(.userInfo)
                                                    } else {
                                                        onboardingState.navigateTo(.quiz(questionNumber + 1))
                                                    }
                                                }
                                            }
                                        }) {
                                            HStack(spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(
                                                            selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                            Color(red: 1.0, green: 0.976, blue: 0.945) : Color.white.opacity(0.1)
                                                        )
                                                        .frame(width: 32, height: 32)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(
                                                                    selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                                    Color(red: 1.0, green: 0.976, blue: 0.945) : Color.white.opacity(0.3),
                                                                    lineWidth: 2
                                                                )
                                                        )
                                                    
                                                    if question.allowsMultipleSelection {
                                                        // Show checkmark for multi-select questions
                                                        Image(systemName: selectedOptions.contains(index) || currentAnswers.contains(index) ? "checkmark" : "")
                                                            .font(.system(size: 14, weight: .bold))
                                                            .foregroundColor(.black)
                                                    } else {
                                                        // Show number for single-select questions
                                                        Text("\(index + 1)")
                                                            .font(.system(size: 14, weight: .bold))
                                                            .foregroundColor(
                                                                selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                                .black : Color(red: 1.0, green: 0.976, blue: 0.945)
                                                            )
                                                    }
                                                }
                                                
                                                Text(option)
                                                    .font(.system(size: 16, weight: .medium))
                                                    .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945))
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(nil)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Spacer()
                                            }
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(
                                                        selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                        Color.white.opacity(0.08) : Color.white.opacity(0.03)
                                                    )
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(
                                                                selectedOptions.contains(index) || currentAnswers.contains(index) ?
                                                                Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.4) : Color.white.opacity(0.1),
                                                                lineWidth: 1.5
                                                            )
                                                    )
                                            )
                                        }
                                        .scaleEffect(selectedOptions.contains(index) || currentAnswers.contains(index) ? 1.02 : 1.0)
                                        .opacity(showOptions ? 1.0 : 0.0)
                                        .offset(y: showOptions ? 0 : 20)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.08), value: showOptions)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedOptions)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, max(geometry.safeAreaInsets.bottom + 60, 80)) // Extra padding to ensure nothing is cut off, especially for Q10 with 6 options
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure ScrollView fills available space
                    }
                
                    // Sticky Continue button for multi-select questions (fixed at bottom)
                    if question.allowsMultipleSelection {
                        VStack(spacing: 0) {
                            // Gradient fade to indicate more content above
                            LinearGradient(
                                colors: [
                                    Color(red: 0.05, green: 0.1, blue: 0.35).opacity(0),
                                    Color(red: 0.05, green: 0.1, blue: 0.35).opacity(0.3),
                                    Color(red: 0.05, green: 0.1, blue: 0.35)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 20)
                            
                            // Button container
                            VStack(spacing: 0) {
                                Button(action: {
                                    // Only proceed if at least one option is selected
                                    guard !selectedOptions.isEmpty else {
                                        let impact = UINotificationFeedbackGenerator()
                                        impact.notificationOccurred(.warning)
                                        return
                                    }
                                    
                                    let impact = UIImpactFeedbackGenerator(style: .medium)
                                    impact.impactOccurred()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        if questionNumber == quizQuestions.count {
                                            onboardingState.navigateTo(.userInfo)
                                        } else {
                                            onboardingState.navigateTo(.quiz(questionNumber + 1))
                                        }
                                    }
                                }) {
                                    Text("Continue")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(selectedOptions.isEmpty ? .gray : .black)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 54)
                                        .background(selectedOptions.isEmpty ? Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.5) : Color(red: 1.0, green: 0.976, blue: 0.945)) // Ivory White #FFF9F1
                                        .clipShape(Capsule())
                                        .shadow(color: selectedOptions.isEmpty ? .clear : .black.opacity(0.25), radius: selectedOptions.isEmpty ? 0 : 12, x: 0, y: selectedOptions.isEmpty ? 0 : 6)
                                }
                                .disabled(selectedOptions.isEmpty)
                                .padding(.horizontal, 24)
                                .padding(.top, 12)
                                .padding(.bottom, max(geometry.safeAreaInsets.bottom + 16, 32))
                            }
                            .background(Color(red: 0.05, green: 0.1, blue: 0.35))
                        }
                        .opacity(showOptions ? 1.0 : 0.0)
                        .offset(y: showOptions ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showOptions)
                    } else {
                        // Bottom spacing for single-select questions
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: geometry.safeAreaInsets.bottom + 32)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .id("question_\(questionNumber)")
        .onAppear {
            // Reset animation states
            isVisible = false
            showContent = false
            showOptions = false
            
                    // Load any previously selected answers
                    selectedOptions = currentAnswers
            
            // Start smooth sequential animations
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showOptions = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuizQuestionView(questionNumber: 1)
            .environmentObject(OnboardingState())
    }
}
