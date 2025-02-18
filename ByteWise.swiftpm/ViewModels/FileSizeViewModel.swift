import Foundation
import Combine
import SwiftUI

@MainActor
final class FileSizeViewModel: ObservableObject {
    @Published var sourceValue: String = ""
    @Published var sourceUnit: FileSizeUnit = .byte
    @Published var targetUnit: FileSizeUnit = .kibibyte
    @Published var score: Int = 0
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var conversionHistory: [FileSizeConversion] = []
    @Published var conversionResult: FileSizeConversionResult?
    
    private var applicationsViewModel: ApplicationsViewModel?
    
    struct FileSizeConversion: Identifiable {
        let id = UUID()
        let sourceValue: Double
        let sourceUnit: FileSizeUnit
        let targetUnit: FileSizeUnit
        let result: Double
        let points: Int
        
        var formattedResult: String {
            String(format: "%.2f %@ = %.2f %@", 
                   sourceValue, sourceUnit.rawValue,
                   result, targetUnit.rawValue)
        }
        
        var binaryExplanation: String {
            let sourceBytes = sourceValue * Double(sourceUnit.multiplier)
            return "\(sourceBytes) bytes ÷ \(targetUnit.multiplier) = \(result) \(targetUnit.rawValue)"
        }
    }
    
    init(applicationsViewModel: ApplicationsViewModel? = nil) {
        self.applicationsViewModel = applicationsViewModel
    }
    
    func setApplicationsViewModel(_ viewModel: ApplicationsViewModel) {
        self.applicationsViewModel = viewModel
    }
    
    func reset() {
        score = 0
        conversionHistory.removeAll()
        sourceValue = ""
    }
    
    func convert() {
        guard let value = Double(sourceValue) else {
            showError("Please enter a valid number")
            return
        }
        
        let steps = calculateConversionSteps(
            from: value,
            sourceUnit: sourceUnit,
            targetUnit: targetUnit
        )
        
        let result = FileSizeConversionResult(
            sourceValue: value,
            sourceUnit: sourceUnit,
            targetValue: steps.result,
            targetUnit: targetUnit,
            binarySteps: steps.explanation
        )
        
        conversionResult = result
        
        // Add to history and update score
        let conversion = FileSizeConversion(
            sourceValue: value,
            sourceUnit: sourceUnit,
            targetUnit: targetUnit,
            result: steps.result,
            points: 30
        )
        conversionHistory.insert(conversion, at: 0)
        score += 30
        
        // Update application progress immediately
        if let appViewModel = applicationsViewModel {
            appViewModel.updateProgress(
                for: .fileSize,
                score: score
            )
        }
        
        // Clear input after conversion
        sourceValue = ""
    }
    
    private func calculateConversionSteps(
        from value: Double,
        sourceUnit: FileSizeUnit,
        targetUnit: FileSizeUnit
    ) -> (result: Double, explanation: [String]) {
        var steps: [String] = []
        let sourceBytes = value * Double(sourceUnit.multiplier)
        steps.append("\(value) \(sourceUnit.rawValue) = \(sourceBytes) bytes")
        
        let result = sourceBytes / Double(targetUnit.multiplier)
        steps.append("\(sourceBytes) bytes = \(String(format: "%.2f", result)) \(targetUnit.rawValue)")
        
        return (result, steps)
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
} 