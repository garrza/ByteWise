import Foundation

struct OperationChallenge: Identifiable {
    let id = UUID()
    let firstNumber: Int
    let secondNumber: Int?  // Optional for NOT operation
    let expectedResult: Int
    let points: Int
    let timestamp = Date()
} 