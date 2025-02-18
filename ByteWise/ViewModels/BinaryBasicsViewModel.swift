import Foundation
import Combine

@MainActor
final class BinaryBasicsViewModel: ObservableObject {
    @Published var bits: [Bool] = Array(repeating: false, count: 8)
    @Published var isChallengeActive = false
    @Published var targetNumber = 0
    @Published var timeRemaining = 30
    @Published var score = 0
    @Published var consecutiveCorrect = 0
    @Published var showGameOver = false
    @Published var scoreHistory: [ScoreEntry] = []
    
    private var timer: Timer?
    private let challengeDuration = 20
    
    var decimalValue: Int {
        var result = 0
        for (index, bit) in bits.enumerated() {
            if bit {
                result += 1 << (7 - index)
            }
        }
        return result
    }
    
    func startChallenge() {
        resetGame()
        isChallengeActive = true
        generateNewTarget()
        startTimer()
    }
    
    func endChallenge() {
        stopTimer()
        showGameOver = true
        isChallengeActive = false
    }
    
    func resetGame() {
        score = 0
        consecutiveCorrect = 0
        timeRemaining = challengeDuration
        targetNumber = 0
        showGameOver = false
        scoreHistory.removeAll()
        bits = Array(repeating: false, count: 8)
        stopTimer()
    }
    
    private func generateNewTarget() {
        targetNumber = Int.random(in: 0...255)
        bits = Array(repeating: false, count: 8)
    }
    
    private func startTimer() {
        stopTimer()
        
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                Task { @MainActor in
                    self?.updateTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        DispatchQueue.main.async { [weak self] in
            self?.timer?.invalidate()
            self?.timer = nil
        }
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            checkAnswer()
        } else {
            endChallenge()
        }
    }
    
    private func checkAnswer() {
        if decimalValue == targetNumber {
            let timeBonus = min(10, timeRemaining / 2)
            let consecutiveBonus = consecutiveCorrect * 5
            let points = 10 + timeBonus + consecutiveBonus
            
            let binaryString = bits.map { $0 ? "1" : "0" }.joined()
            
            let entry = ScoreEntry(
                decimal: targetNumber,
                binary: binaryString,
                points: points
            )
            scoreHistory.insert(entry, at: 0)
            
            if scoreHistory.count > 8 {
                scoreHistory.removeLast()
            }
            
            score += points
            consecutiveCorrect += 1
            generateNewTarget()
        }
    }
    
    deinit {
        DispatchQueue.main.async { [weak self] in
            self?.timer?.invalidate()
        }
    }
} 