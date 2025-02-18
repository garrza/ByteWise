import Foundation

enum PermissionType: String, CaseIterable {
    case read = "READ"
    case write = "WRITE"
    case execute = "EXECUTE"
    
    var symbol: String {
        switch self {
        case .read: return "r"
        case .write: return "w"
        case .execute: return "x"
        }
    }
    
    var explanation: String {
        switch self {
        case .read: return "Permission to view file contents"
        case .write: return "Permission to modify the file"
        case .execute: return "Permission to run the file as a program"
        }
    }
}

enum UserType: String, CaseIterable {
    case owner = "OWNER"
    case group = "GROUP"
    case others = "OTHERS"
    
    var explanation: String {
        switch self {
        case .owner: return "The user who owns the file"
        case .group: return "Users in the file's group"
        case .others: return "All other users"
        }
    }
}

struct PermissionChallenge {
    let description: String
    let expectedBits: [Bool]
    
    func isCorrect(_ bits: [Bool]) -> Bool {
        bits == expectedBits
    }
    
    static func random() -> PermissionChallenge {
        let challenges = [
            PermissionChallenge(
                description: "Set permissions for a private file that only the owner can read and write",
                expectedBits: [true, true, false, false, false, false, false, false, false]
            ),
            PermissionChallenge(
                description: "Set permissions for an executable file that everyone can run, but only the owner can modify",
                expectedBits: [true, true, false, false, false, true, false, false, true]
            ),
            PermissionChallenge(
                description: "Set permissions for a shared file that everyone can read, but only the owner and group can modify",
                expectedBits: [true, true, false, true, true, false, true, false, false]
            ),
            // Add more challenges as needed
        ]
        return challenges.randomElement()!
    }
} 