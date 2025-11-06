//
//  UserSettings.swift
//  Daily Bread
//
//  Persistent user settings for challenges and goals
//

import Foundation

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    private let userDefaults = UserDefaults.standard
    private let challengesKey = "userChallenges"
    private let goalsKey = "userGoals"
    
    @Published var selectedChallenges: Set<Int> = []
    @Published var selectedGoals: Set<Int> = []
    
    private init() {
        loadSettings()
    }
    
    func loadSettings() {
        // Load challenges
        if let challengeArray = userDefaults.array(forKey: challengesKey) as? [Int] {
            selectedChallenges = Set(challengeArray)
        } else {
            // Try to load from onboarding quiz answers
            if let quizAnswers = userDefaults.dictionary(forKey: "quizAnswers") as? [String: [Int]],
               let question4Answers = quizAnswers["4"] {
                selectedChallenges = Set(question4Answers)
                saveSettings()
            }
        }
        
        // Load goals
        if let goalArray = userDefaults.array(forKey: goalsKey) as? [Int] {
            selectedGoals = Set(goalArray)
        } else {
            // Try to load from onboarding quiz answers
            if let quizAnswers = userDefaults.dictionary(forKey: "quizAnswers") as? [String: [Int]],
               let question5Answers = quizAnswers["5"] {
                selectedGoals = Set(question5Answers)
                saveSettings()
            }
        }
    }
    
    func saveSettings() {
        userDefaults.set(Array(selectedChallenges), forKey: challengesKey)
        userDefaults.set(Array(selectedGoals), forKey: goalsKey)
        userDefaults.synchronize()
    }
    
    // Get challenge names from selected indices
    func getChallengeNames() -> [String] {
        let question4 = quizQuestions.first(where: { $0.id == 4 })!
        return selectedChallenges.compactMap { index in
            guard index < question4.options.count else { return nil }
            return question4.options[index]
        }
    }
    
    // Get goal names from selected indices
    func getGoalNames() -> [String] {
        let question5 = quizQuestions.first(where: { $0.id == 5 })!
        return selectedGoals.compactMap { index in
            guard index < question5.options.count else { return nil }
            return question5.options[index]
        }
    }
}

