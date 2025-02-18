import SwiftUI
import Combine

@MainActor
final class ColorCodingViewModel: ObservableObject {
    weak var applicationsViewModel: ApplicationsViewModel?
    
    @Published var redBits: [Bool] = Array(repeating: false, count: 8)
    @Published var greenBits: [Bool] = Array(repeating: false, count: 8)
    @Published var blueBits: [Bool] = Array(repeating: false, count: 8)
    
    @Published var isChallengeActive = false
    @Published var targetColor: Color = .black
    @Published var timeRemaining = 30
    @Published var score = 0
    @Published var hasCompletedChallenge = false
    @Published var colorMatches: [ColorMatch] = []
    @Published var showGameOver = false
    
    private var timer: Timer?
    private var targetRed = 0
    private var targetGreen = 0
    private var targetBlue = 0
    
    var color: Color {
        Color(red: Double(redValue) / 255,
              green: Double(greenValue) / 255,
              blue: Double(blueValue) / 255)
    }
    
    var redValue: Int { binaryToDecimal(redBits) }
    var greenValue: Int { binaryToDecimal(greenBits) }
    var blueValue: Int { binaryToDecimal(blueBits) }
    
    var hexValue: String {
        String(format: "#%02X%02X%02X", redValue, greenValue, blueValue)
    }
    
    init(applicationsViewModel: ApplicationsViewModel? = nil) {
        self.applicationsViewModel = applicationsViewModel
    }
    
    func startChallenge() {
        isChallengeActive = true
        score = 0
        hasCompletedChallenge = false
        timeRemaining = 30
        colorMatches.removeAll()
        showGameOver = false
        redBits = Array(repeating: false, count: 8)
        greenBits = Array(repeating: false, count: 8)
        blueBits = Array(repeating: false, count: 8)
        generateNewTarget()
        startTimer()
    }
    
    func endChallenge() {
        timer?.invalidate()
        timer = nil
        isChallengeActive = false
        showGameOver = true
        
        if let applicationsViewModel = applicationsViewModel {
            applicationsViewModel.updateProgress(
                for: .colorCoding,
                score: score
            )
        }
        
        if score >= 500 {
            hasCompletedChallenge = true
        }
    }
    
    private func generateNewTarget() {
        targetRed = Int.random(in: 0...255)
        targetGreen = Int.random(in: 0...255)
        targetBlue = Int.random(in: 0...255)
        targetColor = Color(
            red: Double(targetRed) / 255,
            green: Double(targetGreen) / 255,
            blue: Double(targetBlue) / 255
        )
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                self.updateTimer()
            }
        }
    }
    
    private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            checkColor()
        } else {
            endChallenge()
        }
    }
    
    private func checkColor() {
        let redDiff = abs(Double(redValue - targetRed) / 255.0)
        let greenDiff = abs(Double(greenValue - targetGreen) / 255.0)
        let blueDiff = abs(Double(blueValue - targetBlue) / 255.0)
        
        let threshold = 0.05
        if redDiff <= threshold && greenDiff <= threshold && blueDiff <= threshold {
            let timeBonus = timeRemaining * 2
            let points = 100 + timeBonus
            score += points
            
            let match = ColorMatch(
                targetColor: targetColor,
                userColor: color,
                targetHex: String(format: "#%02X%02X%02X", targetRed, targetGreen, targetBlue),
                userHex: hexValue,
                points: points
            )
            colorMatches.insert(match, at: 0)
            
            if score >= 500 || colorMatches.count >= 5 {
                hasCompletedChallenge = true
                endChallenge()
            } else {
                generateNewTarget()
            }
        }
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
        (0..<8).map { decimal & (1 << (7 - $0)) != 0 }
    }
} 
