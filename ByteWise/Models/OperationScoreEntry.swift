import Foundation

struct OperationScoreEntry: Identifiable {
    let id = UUID()
    let operation: BinaryOperation
    let firstNumber: Int
    let secondNumber: Int?
    let result: Int
    let points: Int
    let timestamp = Date()
} 