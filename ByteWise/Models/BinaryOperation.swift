import Foundation

enum BinaryOperation: String, CaseIterable {
    case and = "AND"
    case or = "OR"
    case xor = "XOR"
    case not = "NOT"
    case shift = "SHIFT"
    
    var systemImage: String {
        switch self {
        case .and: return "plus.square.fill"
        case .or: return "plus.circle.fill"
        case .xor: return "xmark.circle.fill"
        case .not: return "exclamationmark.circle.fill"
        case .shift: return "arrow.left.arrow.right"
        }
    }
    
    var description: String {
        switch self {
        case .and: return "Learn about the AND operation and its uses in binary logic"
        case .or: return "Explore the OR operation and how it combines binary numbers"
        case .xor: return "Discover the XOR operation and its unique properties"
        case .not: return "Master the NOT operation for binary inversion"
        case .shift: return "Practice binary shifts and their effects on numbers"
        }
    }
    
    var explanation: String {
        switch self {
        case .and:
            return "The AND operation returns 1 only if both input bits are 1, otherwise it returns 0. It's commonly used for masking bits."
        case .or:
            return "The OR operation returns 1 if either input bit is 1. It's useful for combining flags or setting specific bits."
        case .xor:
            return "The XOR operation returns 1 if the input bits are different. It's often used in cryptography and error detection."
        case .not:
            return "The NOT operation inverts each bit, turning 1s to 0s and vice versa. It's used to create the complement of a number."
        case .shift:
            return "The SHIFT operation moves bits left or right. Left shifts multiply by 2, right shifts divide by 2."
        }
    }
} 