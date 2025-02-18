import Foundation
import Combine

@MainActor
final class BinaryOperationsViewModel: ObservableObject {
    @Published var firstNumber: [Bool] = Array(repeating: false, count: 8) {
        didSet {
            performOperation()
        }
    }
    @Published var secondNumber: [Bool] = Array(repeating: false, count: 8) {
        didSet {
            performOperation()
        }
    }
    @Published var result: [Bool] = Array(repeating: false, count: 8)
    @Published var selectedOperation: BinaryOperation = .and {
        didSet {
            performOperation()
        }
    }
    
    @Published var isChallengeActive = false
    @Published var targetResult: Int?
    @Published var timeRemaining = 30
    @Published var score = 0
    @Published var consecutiveCorrect = 0
    @Published var showGameOver = false
    @Published var challengeHistory: [OperationChallenge] = []
    @Published var scoreHistory: [OperationScoreEntry] = []
    
    private var timer: Timer?
    private let challengeDuration = 30
    
    var firstDecimal: Int {
        binaryToDecimal(firstNumber)
    }
    
    var secondDecimal: Int {
        binaryToDecimal(secondNumber)
    }
    
    var resultDecimal: Int {
        binaryToDecimal(result)
    }
    
    func performOperation() {
        switch selectedOperation {
        case .and:
            result = zip(firstNumber, secondNumber).map { $0 && $1 }
        case .or:
            result = zip(firstNumber, secondNumber).map { $0 || $1 }
        case .xor:
            result = zip(firstNumber, secondNumber).map { $0 != $1 }
        case .not:
            result = firstNumber.map { !$0 }
        case .shift:
            result = Array(firstNumber.dropFirst() + [false])
        }
        
        if isChallengeActive {
            checkChallenge()
        }
    }
    
    func startChallenge() {
        isChallengeActive = true
        score = 0
        consecutiveCorrect = 0
        timeRemaining = challengeDuration
        challengeHistory.removeAll()
        generateNewChallenge()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTimer()
            }
        }
    }
    
    private func generateNewChallenge() {
        // Generate random numbers and expected result
        let first = Int.random(in: 0...255)
        let second = selectedOperation == .not || selectedOperation == .shift ? nil : Int.random(in: 0...255)
        
        // Calculate target based on operation
        let target: Int
        switch selectedOperation {
        case .and:
            target = first & second!
        case .or:
            target = first | second!
        case .xor:
            target = first ^ second!
        case .not:
            target = ~first & 0xFF // Keep within 8 bits
        case .shift:
            target = (first << 1) & 0xFF // Keep within 8 bits
        }
        
        targetResult = target
        
        let challenge = OperationChallenge(
            firstNumber: first,
            secondNumber: second,
            expectedResult: target,
            points: 10 + (consecutiveCorrect * 2)
        )
        challengeHistory.insert(challenge, at: 0)
        
        // we keep only last 8 entries
        if challengeHistory.count > 8 {
            challengeHistory.removeLast()
        }
        
        // reset inputs to zero after setting the target
        firstNumber = Array(repeating: false, count: 8)
        secondNumber = Array(repeating: false, count: 8)
    }
    
    private func checkChallenge() {
        let resultValue = binaryToDecimal(result)
        if resultValue == targetResult {
            // Calculate bonus points based on time and consecutive correct answers
            let timeBonus = min(10, timeRemaining / 2)
            let consecutiveBonus = consecutiveCorrect * 2
            let points = 10 + timeBonus + consecutiveBonus
            
            // Add to score history
            let entry = OperationScoreEntry(
                operation: selectedOperation,
                firstNumber: binaryToDecimal(firstNumber),
                secondNumber: selectedOperation == .not || selectedOperation == .shift ? nil : binaryToDecimal(secondNumber),
                result: resultValue,
                points: points
            )
            scoreHistory.insert(entry, at: 0)
            
            // Keep only last 8 entries
            if scoreHistory.count > 8 {
                scoreHistory.removeLast()
            }
            
            score += points
            consecutiveCorrect += 1
            generateNewChallenge()
        }
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            endChallenge()
        }
    }
    
    private func endChallenge() {
        showGameOver = true
        timer?.invalidate()
        timer = nil
        isChallengeActive = false
        targetResult = nil
        scoreHistory.removeAll()
        // Reset numbers
        firstNumber = Array(repeating: false, count: 8)
        secondNumber = Array(repeating: false, count: 8)
        result = Array(repeating: false, count: 8)
    }
    
    private func binaryToDecimal(_ binary: [Bool]) -> Int {
        var result = 0
        for (index, bit) in binary.enumerated() {
            if bit {
                result += 1 << (7 - index)
            }
        }
        return result
    }
    
    private func decimalToBinary(_ decimal: Int) -> [Bool] {
        var binary = Array(repeating: false, count: 8)
        for i in (0..<8).reversed() {
            binary[7-i] = decimal & (1 << i) != 0
        }
        return binary
    }
} 
