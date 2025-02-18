import Foundation
import Combine

struct ASCIIConversion: Identifiable {
    let id = UUID()
    let character: String
    let asciiValue: Int
    let binary: String
    let points: Int
}

@MainActor
final class ASCIITextViewModel: ObservableObject {
    @Published var bits: [Bool] = Array(repeating: false, count: 8)
    @Published var text = ""
    
    @Published var isChallengeActive = false
    @Published var challengeBits: [Bool] = Array(repeating: false, count: 8)
    @Published var targetCharacter: Character?
    @Published var timeRemaining = 30
    @Published var score = 0
    @Published var hasCompletedChallenge = false
    @Published var showGameOver = false
    @Published var challengeInput = ""
    
    @Published var conversionHistory: [ASCIIConversion] = []
    
    private var timer: Timer?
    private var targetAsciiValue: UInt8 = 0
    
    private var applicationsViewModel: ApplicationsViewModel?
    
    var currentCharacter: Character? {
        text.first
    }
    
    var currentAsciiValue: Int? {
        guard let char = currentCharacter else { return nil }
        return Int(char.asciiValue ?? 0)
    }
    
    func updateBitsFromCharacter() {
        guard let ascii = currentCharacter?.asciiValue else {
            bits = Array(repeating: false, count: 8)
            return
        }
        
        bits = (0..<8).map { ascii & (1 << (7 - $0)) != 0 }
    }
    
    func updateCharacterFromBits() {
        var value: UInt8 = 0
        for (index, bit) in bits.enumerated() {
            if bit {
                value |= 1 << (7 - index)
            }
        }
        
        // we will only update if it's a valid ASCII character
        if value <= 127, 
           let scalar = Unicode.Scalar(Int(value)) {
            text = String(Character(scalar))
        }
    }
    
    func startChallenge() {
        isChallengeActive = true
        score = 0
        hasCompletedChallenge = false
        timeRemaining = 30
        challengeBits = Array(repeating: false, count: 8)
        showGameOver = false
        conversionHistory.removeAll()
        generateNewTarget()
        startTimer()
    }
    
    private func generateNewTarget() {
        // Generate printable ASCII characters (32-126)
        targetAsciiValue = UInt8.random(in: 32...126)
        targetCharacter = Character(UnicodeScalar(targetAsciiValue))
        // Set challenge bits to match the target ASCII value
        challengeBits = (0..<8).map { targetAsciiValue & (1 << (7 - $0)) != 0 }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTimer()
            }
        }
    }
    
    private func updateTimer() {
        guard timeRemaining > 0 else {
            endChallenge()
            return
        }
        timeRemaining -= 1
    }
    
    private func endChallenge() {
        timer?.invalidate()
        timer = nil
        showGameOver = true
        hasCompletedChallenge = score >= 600
        
        Task { @MainActor in
            applicationsViewModel?.updateProgress(
                for: .asciiText,
                score: score
            )
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func cleanup() {
        stopTimer()
    }
    
    func setApplicationsViewModel(_ viewModel: ApplicationsViewModel) {
        self.applicationsViewModel = viewModel
        
        // If there's an existing score, update it immediately
        if score > 0 {
            Task { @MainActor in
                applicationsViewModel?.updateProgress(
                    for: .asciiText,
                    score: score
                )
            }
        }
    }
    
    func checkChallengeAnswer() {
        if let inputChar = challengeInput.first,
           let targetChar = targetCharacter,
           inputChar == targetChar {

            let points = 100 + timeRemaining * 2
            score += points
            
            let conversion = ASCIIConversion(
                character: String(targetChar),
                asciiValue: Int(targetChar.asciiValue ?? 0),
                binary: challengeBits.map { $0 ? "1" : "0" }.joined(),
                points: points
            )
            conversionHistory.insert(conversion, at: 0)
            
            if conversionHistory.count > 5 {
                conversionHistory.removeLast()
            }
            
            hasCompletedChallenge = score >= 600
            
            if hasCompletedChallenge {
                showGameOver = true
                endChallenge()
            } else {
                generateNewTarget()
                timeRemaining = min(timeRemaining + 5, 30)
                challengeInput = ""
            }
        }
    }
    
    func exitChallenge() {
        isChallengeActive = false
        showGameOver = false
    }
} 
