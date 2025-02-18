import Foundation
import Combine

@MainActor
final class FilePermissionsViewModel: ObservableObject {
    @Published var bits: [Bool] = Array(repeating: false, count: 9)
    @Published var isChallengeActive = false
    @Published var timeRemaining = 30
    @Published var score: Int = 0
    @Published var hasCompletedChallenge = false
    @Published var currentChallenge: PermissionChallenge?
    @Published var conversionHistory: [PermissionConversion] = []
    
    private var timer: Timer?
    private var applicationsViewModel: ApplicationsViewModel?
    
    struct PermissionConversion: Identifiable {
        let id = UUID()
        let symbolic: String
        let octal: String
        let points: Int
        let timestamp = Date()
    }
    
    func setApplicationsViewModel(_ viewModel: ApplicationsViewModel) {
        self.applicationsViewModel = viewModel
    }
    
    var symbolicNotation: String {
        var result = ""
        for i in 0..<3 {
            let offset = i * 3
            result += bits[offset] ? "r" : "-"
            result += bits[offset + 1] ? "w" : "-"
            result += bits[offset + 2] ? "x" : "-"
        }
        return result
    }
    
    var octalNotation: String {
        var result = ""
        for i in 0..<3 {
            let offset = i * 3
            var value = 0
            if bits[offset] { value += 4 }     // read
            if bits[offset + 1] { value += 2 } // write
            if bits[offset + 2] { value += 1 } // execute
            result += String(value)
        }
        return result
    }
    
    var naturalLanguageDescription: String {
        var descriptions: [String] = []
        
        for (index, userType) in UserType.allCases.enumerated() {
            var permissions: [String] = []
            let offset = index * 3
            
            if bits[offset] { permissions.append("read") }
            if bits[offset + 1] { permissions.append("write") }
            if bits[offset + 2] { permissions.append("execute") }
            
            if permissions.isEmpty {
                descriptions.append("\(userType.rawValue.lowercased()) has no permissions")
            } else {
                let permissionList = permissions.joined(separator: ", ")
                descriptions.append("\(userType.rawValue.lowercased()) can \(permissionList)")
            }
        }
        
        return descriptions.joined(separator: "; ")
    }
    
    func hasPermission(_ type: PermissionType, for user: UserType) -> Bool {
        let offset = UserType.allCases.firstIndex(of: user)! * 3
        switch type {
        case .read: return bits[offset]
        case .write: return bits[offset + 1]
        case .execute: return bits[offset + 2]
        }
    }
    
    func togglePermission(_ type: PermissionType, for user: UserType) {
        let offset = UserType.allCases.firstIndex(of: user)! * 3
        switch type {
        case .read: bits[offset].toggle()
        case .write: bits[offset + 1].toggle()
        case .execute: bits[offset + 2].toggle()
        }
        
        // Record conversion and update score
        let conversion = PermissionConversion(
            symbolic: symbolicNotation,
            octal: octalNotation,
            points: 10
        )
        conversionHistory.insert(conversion, at: 0)
        score += 10
        
        // Update application progress
        if let appViewModel = applicationsViewModel {
            appViewModel.updateProgress(
                for: .permissions,
                score: score
            )
        }
    }
    
    func setPreset(_ octal: String) {
        guard octal.count == 3, let value = Int(octal, radix: 8) else { return }
        for i in 0..<3 {
            let digit = (value >> ((2 - i) * 3)) & 0b111
            bits[i * 3] = (digit & 0b100) != 0     // read
            bits[i * 3 + 1] = (digit & 0b010) != 0 // write
            bits[i * 3 + 2] = (digit & 0b001) != 0 // execute
        }
    }
    
    func startChallenge() {
        isChallengeActive = true
        score = 0
        hasCompletedChallenge = false
        timeRemaining = 30
        generateNewChallenge()
        startTimer()
    }
    
    private func generateNewChallenge() {
        currentChallenge = PermissionChallenge.random()
        bits = Array(repeating: false, count: 9)
    }
    
    func submitAnswer() {
        guard let challenge = currentChallenge else { return }
        
        if challenge.isCorrect(bits) {
            let timeBonus = timeRemaining * 2
            score += 100 + timeBonus
            
            // Update completion check
            hasCompletedChallenge = score >= Achievement.permissionPro.requiredScore
            
            generateNewChallenge()
        }
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
        isChallengeActive = false
        hasCompletedChallenge = true
        currentChallenge = nil
    }
    
    func reset() {
        bits = Array(repeating: false, count: 9)
        score = 0
        conversionHistory.removeAll()
    }
} 