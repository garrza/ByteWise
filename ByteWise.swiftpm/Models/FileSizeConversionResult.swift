import Foundation

struct FileSizeConversionResult {
    let sourceValue: Double
    let sourceUnit: FileSizeUnit
    let targetValue: Double
    let targetUnit: FileSizeUnit
    let binarySteps: [String]
    
    var formattedResult: String {
        String(format: "%.2f %@ = %.2f %@", 
               sourceValue, sourceUnit.rawValue,
               targetValue, targetUnit.rawValue)
    }
    
    var binaryExplanation: String {
        binarySteps.joined(separator: "\n")
    }
} 