import Foundation

struct QuizQuestion: Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let subtitle: String? // Optional subtitle for additional context
    let allowsMultipleSelection: Bool // New property for multi-select questions
}

let quizQuestions: [QuizQuestion] = [
    // Question 1: Easy Start - Build Momentum
    QuizQuestion(
        id: 1,
        question: "What is your gender?",
        options: ["Male", "Female"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Question 2: Early Problem Recognition - Quantify the Issue
    QuizQuestion(
        id: 2,
        question: "How many hours per day do you spend on your phone?",
        options: ["Less than 2 hours", "2-4 hours", "4-6 hours", "6-8 hours", "More than 8 hours", "I'm not sure"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Question 3: Emotional Impact - Feel the Pain
    QuizQuestion(
        id: 3,
        question: "How does social media make you feel?",
        options: ["Connected and happy", "Stressed and anxious", "Envious and insecure", "Wasteful and guilty", "Distracted from what matters", "All of the above"],
        subtitle: "Select all that apply",
        allowsMultipleSelection: true
    ),
    
    // Question 4: Problem Awareness - Acknowledge the Behavior
    QuizQuestion(
        id: 4,
        question: "Do you scroll instead of praying or reading the Bible?",
        options: ["Every day", "Most days", "Sometimes", "Rarely", "Never"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Question 5: Spiritual Disconnect - Core Problem Recognition
    QuizQuestion(
        id: 5,
        question: "Do you feel your phone habits are hurting your relationship with God?",
        options: ["Yes, significantly", "Yes, somewhat", "Sometimes", "Rarely", "No, not at all"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Question 6: Show They Need Help - Previous Failures
    QuizQuestion(
        id: 6,
        question: "Have you tried to reduce your social media use but struggled?",
        options: ["Yes, multiple times", "Yes, a few times", "Yes, once", "No, but I want to", "No, I don't see it as a problem"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Question 7: Personal Struggles - Deeper Connection
    QuizQuestion(
        id: 7,
        question: "What challenges are you currently facing?",
        options: ["Lust", "Alcohol addiction", "Smoking/Drugs", "Anxiety", "Depression", "Anger", "Pride", "Greed", "Envy", "Laziness", "Fear", "Doubt", "Loneliness", "Grief", "Financial stress", "Relationship issues", "Work stress", "Health problems"],
        subtitle: "Select all that apply",
        allowsMultipleSelection: true
    ),
    
    // Question 8: Vision/Goals - What They Want (Hope)
    QuizQuestion(
        id: 8,
        question: "What are your main spiritual goals?",
        options: ["Grow closer to God", "Overcome specific sins", "Find peace and comfort", "Gain wisdom for decisions", "Strengthen my faith", "Serve others better", "Find my purpose"],
        subtitle: "Select all that apply",
        allowsMultipleSelection: true
    ),
    
    // Question 9: Basic Info - Easy After Heavy Questions
    QuizQuestion(
        id: 9,
        question: "What is your Christian denomination?",
        options: ["Catholic", "Protestant", "Baptist", "Methodist", "Presbyterian", "Lutheran", "Pentecostal", "Non-denominational", "Other", "I'm not sure"],
        subtitle: nil,
        allowsMultipleSelection: false
    ),
    
    // Question 10: Preference - Easy Finale
    QuizQuestion(
        id: 10,
        question: "Which Bible version do you prefer?",
        options: [
            "New International Version (NIV)",
            "English Standard Version (ESV)",
            "King James Version (KJV)",
            "New Living Translation (NLT)",
            "New King James Version (NKJV)",
            "Christian Standard Bible (CSB)"
        ],
        subtitle: nil,
        allowsMultipleSelection: false
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