import SwiftUI

@MainActor
final class ApplicationsViewModel: ObservableObject {
    @Published var selectedApplication: BinaryApplication?
    @Published var applicationProgress: [BinaryApplication: ApplicationProgress] = [:]
    
    private var progressManager: ProgressManager
    
    init() {
        self.progressManager = ProgressManager()
        loadProgress()
    }
    
    func updateProgressManager(_ newProgressManager: ProgressManager) {
        self.progressManager = newProgressManager
        loadProgress()
    }
    
    func updateProgress(for application: BinaryApplication, score: Int = 0) {
        var progress = applicationProgress[application] ?? ApplicationProgress()
        progress.completed = true
        progress.score += score
        progress.lastAccessed = Date()
        applicationProgress[application] = progress
        
        progressManager.updateProgress(
            for: "App_\(application.rawValue)",
            completed: true,
            score: progress.score
        )
        
        checkAchievements(for: application)
    }
    
    private func checkAchievements(for application: BinaryApplication) {
        guard let progress = applicationProgress[application] else { return }
        
        let achievement = Achievement.forApplication(application)
        if progress.score >= achievement.requiredScore {
            awardAchievement(achievement.id, for: application)
        }
    }
    
    private func awardAchievement(_ achievement: String, for application: BinaryApplication) {
        var progress = applicationProgress[application] ?? ApplicationProgress()
        progress.achievements.insert(achievement)
        applicationProgress[application] = progress
        
        var moduleProgress = progressManager.moduleProgress["App_\(application.rawValue)"] ?? ModuleProgress(completed: false, score: 0, achievements: [], lastAccessed: Date())
        moduleProgress.achievements.insert(achievement)
        progressManager.moduleProgress["App_\(application.rawValue)"] = moduleProgress
    }
    
    private func loadProgress() {
        for application in BinaryApplication.allCases {
            if let moduleProgress = progressManager.moduleProgress["App_\(application.rawValue)"] {
                let progress = ApplicationProgress(
                    completed: moduleProgress.completed,
                    score: moduleProgress.score,
                    lastAccessed: moduleProgress.lastAccessed,
                    achievements: moduleProgress.achievements
                )
                applicationProgress[application] = progress
            } else {
                applicationProgress[application] = ApplicationProgress()
            }
        }
    }
    
    func resetAllProgress() {
        for application in BinaryApplication.allCases {
            applicationProgress[application] = ApplicationProgress()
            progressManager.moduleProgress["App_\(application.rawValue)"] = ModuleProgress(
                completed: false,
                score: 0,
                achievements: [],
                lastAccessed: Date()
            )
        }
        progressManager.saveProgress()
    }
} 
