//
//  BibleVerse.swift
//  Daily Bread
//
//  Model for Bible verses with devotional content
//

import Foundation

struct BibleVerse: Identifiable, Codable {
    let id: UUID
    let text: String
    let reference: String
    let devotional: String // 2-3 sentence devotional
    let backgroundImage: String // Image name (b1, b2, b3, etc.)
    let tags: [String] // Tags for matching (anxiety, prayer, peace, etc.)
    
    init(id: UUID = UUID(), text: String, reference: String, devotional: String, backgroundImage: String, tags: [String]) {
        self.id = id
        self.text = text
        self.reference = reference
        self.devotional = devotional
        self.backgroundImage = backgroundImage
        self.tags = tags
    }
}

// Verse database - personalized verses based on challenges/goals
class VerseDatabase {
    static let shared = VerseDatabase()
    
    private let verses: [BibleVerse] = [
        // Anxiety/Stress verses
        BibleVerse(
            text: "For I, the Lord your God, will hold your right hand, saying to you, 'Don't be afraid. I will help you.'",
            reference: "ISAIAH 41:13",
            devotional: "When anxiety creeps in, remember that God is holding your hand. He's not distant or unaware—He's right beside you, ready to help. Take a deep breath and trust that His strength is greater than your worries.",
            backgroundImage: "b1",
            tags: ["anxiety", "stress", "fear", "help"]
        ),
        BibleVerse(
            text: "Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.",
            reference: "PHILIPPIANS 4:6",
            devotional: "Anxiety doesn't have to control you. God invites you to bring every worry to Him in prayer. When you're tempted to scroll through social media to escape, pause and talk to God instead. He's listening.",
            backgroundImage: "b2",
            tags: ["anxiety", "prayer", "peace", "worry"]
        ),
        BibleVerse(
            text: "Come to me, all you who are weary and burdened, and I will give you rest.",
            reference: "MATTHEW 11:28",
            devotional: "You don't have to carry your burdens alone. Jesus offers rest for your soul—not just physical rest, but deep spiritual peace. When you feel overwhelmed, come to Him. He's waiting.",
            backgroundImage: "b3",
            tags: ["rest", "peace", "burden", "anxiety"]
        ),
        
        // Prayer verses
        BibleVerse(
            text: "Pray continually.",
            reference: "1 THESSALONIANS 5:17",
            devotional: "Prayer isn't just for church or before meals—it's a constant conversation with God. When you're scrolling, pause and talk to Him. When you're stressed, tell Him. He's always listening.",
            backgroundImage: "b4",
            tags: ["prayer", "communication", "connection"]
        ),
        BibleVerse(
            text: "But when you pray, go into your room, close the door and pray to your Father, who is unseen.",
            reference: "MATTHEW 6:6",
            devotional: "True prayer happens in quiet moments, away from distractions. God wants your undivided attention. Close the apps, find a quiet space, and talk to your Heavenly Father. He's waiting to hear from you.",
            backgroundImage: "b5",
            tags: ["prayer", "quiet", "distraction", "focus"]
        ),
        
        // Peace verses
        BibleVerse(
            text: "Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled and do not be afraid.",
            reference: "JOHN 14:27",
            devotional: "The world offers temporary distractions, but Jesus offers lasting peace. His peace isn't dependent on circumstances—it's a gift. When chaos surrounds you, remember His promise of peace.",
            backgroundImage: "b1",
            tags: ["peace", "fear", "trouble", "world"]
        ),
        
        // Trust/Future verses
        BibleVerse(
            text: "For I know the plans I have for you,\" declares the Lord, \"plans to prosper you and not to harm you, plans to give you hope and a future.",
            reference: "JEREMIAH 29:11",
            devotional: "Your future isn't uncertain to God. He has a plan—one filled with hope and purpose. When you're tempted to compare your life to others on social media, remember God's unique plan for you.",
            backgroundImage: "b2",
            tags: ["future", "hope", "plans", "trust"]
        ),
        
        // Strength verses
        BibleVerse(
            text: "I can do all this through him who gives me strength.",
            reference: "PHILIPPIANS 4:13",
            devotional: "You're not alone in your struggles. God provides the strength you need—not just to survive, but to thrive. When you feel weak, remember that His power is made perfect in your weakness.",
            backgroundImage: "b3",
            tags: ["strength", "power", "ability", "help"]
        ),
        
        // Love verses
        BibleVerse(
            text: "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.",
            reference: "JOHN 3:16",
            devotional: "You are deeply loved. God's love isn't based on your performance or how many likes you get. It's unconditional, sacrificial, and eternal. Rest in that love today.",
            backgroundImage: "b4",
            tags: ["love", "sacrifice", "eternal", "value"]
        ),
        
        // Distraction/Focus verses
        BibleVerse(
            text: "Set your minds on things above, not on earthly things.",
            reference: "COLOSSIANS 3:2",
            devotional: "Where you focus determines your peace. Social media pulls your attention to temporary things, but God invites you to focus on what truly matters—eternal things. Choose wisely where you invest your attention.",
            backgroundImage: "b5",
            tags: ["focus", "distraction", "priorities", "earthly"]
        ),
        
        // Identity verses
        BibleVerse(
            text: "So God created mankind in his own image, in the image of God he created them.",
            reference: "GENESIS 1:27",
            devotional: "Your worth isn't determined by followers, likes, or comparisons. You're made in God's image—precious, valuable, and loved. When social media makes you feel less than, remember whose image you bear.",
            backgroundImage: "b1",
            tags: ["identity", "worth", "value", "image"]
        )
    ]
    
    private init() {}
    
    // Get personalized verse based on user's challenges and goals
    func getTodaysVerse(challenges: Set<Int>, goals: Set<Int>) -> BibleVerse {
        // Get challenge and goal names
        let userSettings = UserSettings.shared
        let challengeNames = userSettings.getChallengeNames()
        let goalNames = userSettings.getGoalNames()
        
        // Create a set of relevant tags based on user's selections
        var relevantTags: Set<String> = []
        
        // Map challenges to tags
        for challenge in challengeNames {
            let lowercased = challenge.lowercased()
            if lowercased.contains("anxious") || lowercased.contains("stressed") {
                relevantTags.insert("anxiety")
                relevantTags.insert("stress")
            }
            if lowercased.contains("envious") || lowercased.contains("insecure") {
                relevantTags.insert("identity")
                relevantTags.insert("worth")
            }
            if lowercased.contains("distracted") {
                relevantTags.insert("distraction")
                relevantTags.insert("focus")
            }
        }
        
        // Map goals to tags
        for goal in goalNames {
            let lowercased = goal.lowercased()
            if lowercased.contains("prayer") {
                relevantTags.insert("prayer")
            }
            if lowercased.contains("peace") || lowercased.contains("joy") {
                relevantTags.insert("peace")
            }
            if lowercased.contains("growth") {
                relevantTags.insert("trust")
                relevantTags.insert("strength")
            }
        }
        
        // If no specific tags, use default tags
        if relevantTags.isEmpty {
            relevantTags = ["peace", "anxiety", "prayer"]
        }
        
        // Find verses that match user's tags
        let matchingVerses = verses.filter { verse in
            verse.tags.contains { relevantTags.contains($0) }
        }
        
        // If we have matches, pick one (use date to make it consistent per day)
        if !matchingVerses.isEmpty {
            let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
            return matchingVerses[dayOfYear % matchingVerses.count]
        }
        
        // Fallback to first verse
        return verses[0]
    }
    
    // Get verse for a specific date (for consistency)
    func getVerseForDate(date: Date, challenges: Set<Int>, goals: Set<Int>) -> BibleVerse {
        // Use the same logic but seed with date
        return getTodaysVerse(challenges: challenges, goals: goals)
    }
}

