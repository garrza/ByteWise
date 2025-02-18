import Foundation

struct ApplicationProgress: Codable {
    var completed: Bool
    var score: Int
    var lastAccessed: Date
    var hexConversions: [HexConversion]
    var achievements: Set<String>
    
    init() {
        self.completed = false
        self.score = 0
        self.lastAccessed = Date()
        self.hexConversions = []
        self.achievements = []
    }
    
    init(completed: Bool, score: Int, lastAccessed: Date, achievements: Set<String>) {
        self.completed = completed
        self.score = score
        self.lastAccessed = lastAccessed
        self.hexConversions = []
        self.achievements = achievements
    }
} 