import Foundation

struct QuizQuestion: Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let subtitle: String? // Optional subtitle for additional context
    let allowsMultipleSelection: Bool // New property for multi-select questions
}

let quizQuestions: [QuizQuestion] = [
    // Basic Demographics
    QuizQuestion(
        id: 1,
        question: "What is your gender?",
        options: ["Male", "Female"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Denomination
    QuizQuestion(
        id: 2,
        question: "What is your Christian denomination?",
        options: ["Catholic", "Protestant", "Baptist", "Methodist", "Presbyterian", "Lutheran", "Pentecostal", "Non-denominational", "Other", "I'm not sure"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Bible Version Preference
    QuizQuestion(
        id: 3,
        question: "Which Bible version do you prefer?",
        options: ["New International Version (NIV)", "King James Version (KJV)", "New Living Translation (NLT)", "English Standard Version (ESV)", "New King James Version (NKJV)", "New American Bible (NAB)"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Life Struggles - Multiple Selection
    QuizQuestion(
        id: 4,
        question: "What challenges are you currently facing?",
        options: ["Lust", "Alcohol addiction", "Smoking/Drugs", "Anxiety", "Depression", "Anger", "Pride", "Greed", "Envy", "Laziness", "Fear", "Doubt", "Loneliness", "Grief", "Financial stress", "Relationship issues", "Work stress", "Health problems", "None of these"],
        subtitle: "Select all that apply",
        allowsMultipleSelection: true
    ),
    
    // Goals
    QuizQuestion(
        id: 5,
        question: "What are your main spiritual goals?",
        options: ["Grow closer to God", "Overcome specific sins", "Find peace and comfort", "Gain wisdom for decisions", "Strengthen my faith", "Serve others better", "Find my purpose", "All of the above"],
        subtitle: "Select all that apply",
        allowsMultipleSelection: true
    )
]

// Goals selection
struct Goal: Identifiable {
    let id: Int
    let title: String
    let description: String
}

let availableGoals: [Goal] = [
    Goal(id: 1, title: "Daily Devotion", description: "Build consistent spiritual habits"),
    Goal(id: 2, title: "Prayer Life", description: "Deepen your communication with God"),
    Goal(id: 3, title: "Scripture Study", description: "Grow in biblical understanding"),
    Goal(id: 4, title: "Community", description: "Connect with fellow believers"),
    Goal(id: 5, title: "Spiritual Growth", description: "Mature in your faith journey"),
    Goal(id: 6, title: "Peace & Joy", description: "Find God's peace in daily life"),
    Goal(id: 7, title: "Service", description: "Use your gifts to serve others"),
    Goal(id: 8, title: "Worship", description: "Express your love for God")
]