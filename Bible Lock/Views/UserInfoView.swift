import SwiftUI
import Foundation

struct UserInfoView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss
    @State private var isVisible = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var hasInteractedWithName = false
    @State private var hasInteractedWithAge = false
    @State private var gradientOffset: Double = 0
    
    private enum Field {
        case name, age
    }
    
    private var isFormValid: Bool {
        !onboardingState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && 
        !onboardingState.age.isEmpty &&
        Int(onboardingState.age) != nil &&
        (Int(onboardingState.age) ?? 0) >= 10 &&
        (Int(onboardingState.age) ?? 0) <= 99
    }
    
    private var isNameValid: Bool {
        if !hasInteractedWithName { return true }
        return !onboardingState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var isAgeValid: Bool {
        if !hasInteractedWithAge || onboardingState.age.isEmpty { return true }
        if let age = Int(onboardingState.age) {
            return age >= 10 && age <= 99
        }
        return false
    }
    
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
                
                // Additional depth layer with royal blue accent (exact same hue, lighter)
                RadialGradient(
                    colors: [
                        Color(red: 0.25, green: 0.5, blue: 0.85).opacity(0.4), // Lighter tint of royal blue (maintains 1:2:3.4 ratio)
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
                
                // Enhanced animated particles (royal blue - exact hue) - stable position per page
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
                
                VStack(spacing: 0) {
                    // Main content - adjusted positioning to move text up
                    VStack(spacing: 0) {
                        // Title section - positioned higher
                        VStack(spacing: 12) {
                            Text("Finally")
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // Ivory White #FFF9F1
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.8), value: isVisible)
                            
                            Text("A little more about you")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.7)) // Ivory White #FFF9F1
                                .multilineTextAlignment(.center)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.8), value: isVisible)
                        }
                        .padding(.top, geometry.safeAreaInsets.top + 50)
                        
                        // Form fields - positioned directly under subtitle
                        VStack(spacing: 20) {
                            // Name field
                            ZStack(alignment: .leading) {
                                HStack(spacing: 16) {
                                    // Input field area
                                    ZStack(alignment: .leading) {
                                        if onboardingState.name.isEmpty {
                                            Text("Name")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.6)) // Ivory White #FFF9F1
                                        }
                                        
                                        TextField("", text: $onboardingState.name)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // Ivory White #FFF9F1
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .focused($focusedField, equals: .name)
                                            .submitLabel(.next)
                                            .textInputAutocapitalization(.words)
                                            .autocorrectionDisabled()
                                            .onSubmit {
                                                focusedField = .age
                                            }
                                            .onChange(of: onboardingState.name) {
                                                hasInteractedWithName = true
                                            }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.015))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                        )
                                )
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8), value: isVisible)
                            
                            // Age field
                            ZStack(alignment: .leading) {
                                HStack(spacing: 16) {
                                    // Input field area
                                    ZStack(alignment: .leading) {
                                        if onboardingState.age.isEmpty {
                                            Text("Age")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(0.6)) // Ivory White #FFF9F1
                                        }
                                        
                                        TextField("", text: $onboardingState.age)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color(red: 1.0, green: 0.976, blue: 0.945)) // Ivory White #FFF9F1
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .keyboardType(.numberPad)
                                            .focused($focusedField, equals: .age)
                                            .submitLabel(.done)
                                            .onSubmit {
                                                focusedField = nil
                                            }
                                            .onChange(of: onboardingState.age) {
                                                hasInteractedWithAge = true
                                                // Filter non-numeric characters
                                                let filtered = onboardingState.age.filter { "0123456789".contains($0) }
                                                if filtered != onboardingState.age {
                                                    onboardingState.age = filtered
                                                }
                                            }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.015))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                        )
                                )
                            }
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8), value: isVisible)
                            
                            // Complete Setup button - positioned directly under Age field
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                focusedField = nil // Dismiss keyboard first
                                
                                // Persist name for later use
                                let trimmedName = onboardingState.name.trimmingCharacters(in: .whitespacesAndNewlines)
                                if !trimmedName.isEmpty {
                                    UserDefaults.standard.set(trimmedName, forKey: "userDisplayName")
                                }
                                if let ageInt = Int(onboardingState.age) { 
                                    UserDefaults.standard.set(ageInt, forKey: "userAge") 
                                }
                                
                                // Save quiz answers (including challenges and goals) to UserSettings
                                let userSettings = UserSettings.shared
                                if let question4Answers = onboardingState.quizAnswers[4] {
                                    userSettings.selectedChallenges = Set(question4Answers)
                                }
                                if let question5Answers = onboardingState.quizAnswers[5] {
                                    userSettings.selectedGoals = Set(question5Answers)
                                }
                                userSettings.saveSettings()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    onboardingState.navigateTo(.creatingPlan)
                                }
                            }) {
                                Text("Complete Setup")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color(red: 1.0, green: 0.976, blue: 0.945).opacity(isFormValid ? 0.9 : 0.5)) // Ivory White #FFF9F1
                                    )
                            }
                            .disabled(!isFormValid)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.8), value: isVisible)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                    
                    Spacer()
                }
                    
                    // Bottom safe area spacing
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: geometry.safeAreaInsets.bottom)
                    }
                }
            }
        .navigationBarHidden(true)
        .onAppear {
            gradientOffset = 0.3
            // Immediate, smooth fade-in - no jarring delays
            withAnimation(.easeOut(duration: 0.8)) {
                isVisible = true
            }
            
            // Add subtle haptic feedback for better user experience
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // Start with name field focused after animations settle
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                focusedField = .name
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                withAnimation(.easeInOut(duration: 0.3)) {
                    keyboardHeight = keyboardFrame.cgRectValue.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                keyboardHeight = 0
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserInfoView()
            .environmentObject(OnboardingState())
    }
}
