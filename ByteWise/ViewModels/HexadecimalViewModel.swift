import Foundation
import Combine

@MainActor
final class HexadecimalViewModel: ObservableObject {
    @Published var bits: [Bool] = Array(repeating: false, count: 8)
    @Published var hexInput = ""
    @Published var isChallengeActive = false
    @Published var targetHex = ""
    @Published var timeRemaining = 30
    @Published var score = 0
    @Published var consecutiveCorrect = 0
    @Published var showGameOver = false
    @Published var conversionHistory: [HexConversion] = []
    @Published var playgroundBits: [Bool] = Array(repeating: false, count: 8)
    @Published var challengeBits: [Bool] = Array(repeating: false, count: 8)
    
    private var timer: Timer?
    private let challengeDuration = 20
    
    var decimalValue: Int {
        var result = 0
        for (index, bit) in playgroundBits.enumerated() {
            if bit {
                result += 1 << (7 - index)
            }
        }
        return result
    }
    
    var hexValue: String {
        String(format: "%02X", decimalValue)
    }
    
    var targetDecimal: Int {
        Int(targetHex, radix: 16) ?? 0
    }
    
    func updateFromHex() {
        // Only allow valid hex characters and limit to 2 digits
        let filtered = hexInput.uppercased().filter { $0.isHexDigit }
        if filtered != hexInput {
            hexInput = filtered
        }
        if hexInput.count > 2 {
            hexInput = String(hexInput.prefix(2))
        }
        
        // Convert hex to binary
        if let decimal = Int(hexInput, radix: 16) {
            playgroundBits = (0..<8).map { decimal & (1 << (7 - $0)) != 0 }
        }
    }
    
    func startChallenge() {
        isChallengeActive = true
        score = 0
        consecutiveCorrect = 0
        timeRemaining = challengeDuration
        showGameOver = false
        playgroundBits = Array(repeating: false, count: 8)
        challengeBits = Array(repeating: false, count: 8)
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
        targetHex = ""
        showGameOver = false
        conversionHistory.removeAll()
        challengeBits = Array(repeating: false, count: 8)
        stopTimer()
    }
    
    private func generateNewTarget() {
        let decimal = Int.random(in: 0...255)
        targetHex = String(format: "%02X", decimal)
        challengeBits = Array(repeating: false, count: 8)
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
        let challengeHex = String(format: "%02X", challengeDecimalValue())
        if challengeHex == targetHex {
            let timeBonus = min(10, timeRemaining / 2)
            let consecutiveBonus = consecutiveCorrect * 5
            let points = 10 + timeBonus + consecutiveBonus
            
            let entry = HexConversion(
                decimal: challengeDecimalValue(),
                binary: challengeBits.map { $0 ? "1" : "0" }.joined(),
                hex: challengeHex,
                points: points
            )
            conversionHistory.insert(entry, at: 0)
            
            if conversionHistory.count > 8 {
                conversionHistory.removeLast()
            }
            
            score += points
            consecutiveCorrect += 1
            generateNewTarget()
        }
    }
    
    private func challengeDecimalValue() -> Int {
        var result = 0
        for (index, bit) in challengeBits.enumerated() {
            if bit {
                result += 1 << (7 - index)
            }
        }
        return result
    }
    
    deinit {
        DispatchQueue.main.async { [weak self] in
            self?.timer?.invalidate()
        }
    }
} 