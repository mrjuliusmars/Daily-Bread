import SwiftUI

// MARK: - OnboardingFlow Enum
enum OnboardingFlow: Hashable {
    case onboardingCarousel
    case quiz(Int)
    case userInfo
    case creatingPlan
    case planReady
}

// MARK: - OnboardingState Class
class OnboardingState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var quizAnswers: [Int: [Int]] = [:] // Changed to support multiple selections
    
    func navigateTo(_ destination: OnboardingFlow) {
        path.append(destination)
    }
    
    func clearPath() {
        path = NavigationPath()
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // Helper method to get quiz score
    var quizScore: Int {
        // Calculate score based on quiz answers
        let totalQuestions = quizAnswers.count
        let totalScore = quizAnswers.values.flatMap { $0 }.reduce(0, +)
        
        if totalQuestions > 0 {
            return min(100, (totalScore * 100) / (totalQuestions * 3)) // Assuming 3 options per question
        }
        
        return 75 // Default score
    }
    
    // Helper method to get user profile data
    var userProfile: [String: Any] {
        var profile: [String: Any] = [:]
        
        // Basic info
        profile["name"] = name
        profile["age"] = age
        
        // Quiz answers
        for (questionId, answers) in quizAnswers {
            profile["question_\(questionId)"] = answers
        }
        
        return profile
    }
}
