import Foundation

struct ScoreEntry: Identifiable {
    let id = UUID()
    let decimal: Int
    let binary: String
    let points: Int
    let timestamp = Date()
} 