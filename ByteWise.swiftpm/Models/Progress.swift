import Foundation

struct ModuleProgress: Codable {
    var completed: Bool
    var score: Int
    var achievements: Set<String>
    var lastAccessed: Date
}

class ProgressManager: ObservableObject {
    @Published var moduleProgress: [String: ModuleProgress] = [:]
    
    private let defaults = UserDefaults.standard
    private let progressKey = "moduleProgress"
    
    init() {
        loadProgress()
    }
    
    func updateProgress(for module: String, completed: Bool, score: Int) {
        var progress = moduleProgress[module] ?? ModuleProgress(completed: false, score: 0, achievements: [], lastAccessed: Date())
        progress.completed = completed
        progress.score = score
        progress.lastAccessed = Date()
        moduleProgress[module] = progress
        saveProgress()
    }
    
    func addAchievement(_ achievement: String, for module: String) {
        var progress = moduleProgress[module] ?? ModuleProgress(completed: false, score: 0, achievements: [], lastAccessed: Date())
        progress.achievements.insert(achievement)
        moduleProgress[module] = progress
        saveProgress()
    }
    
    func saveProgress() {
        if let encoded = try? JSONEncoder().encode(moduleProgress) {
            defaults.set(encoded, forKey: progressKey)
        }
    }
    
    private func loadProgress() {
        if let data = defaults.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([String: ModuleProgress].self, from: data) {
            moduleProgress = decoded
        }
    }
} 