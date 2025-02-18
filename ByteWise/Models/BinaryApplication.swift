import Foundation
import SwiftUI

enum BinaryApplication: String, CaseIterable, Identifiable {
    case colorCoding = "COLOR CODING"
    case fileSize = "FILE SIZES"
    case asciiText = "ASCII TEXT"
    case permissions = "FILE PERMISSIONS"
    
    var id: String { rawValue }
    
    var systemImage: String {
        switch self {
        case .colorCoding: return "paintpalette.fill"
        case .fileSize: return "internaldrive.fill"
        case .asciiText: return "character.textbox"
        case .permissions: return "lock.shield.fill"
        }
    }
    
    var themeColor: Color {
        switch self {
        case .colorCoding: return .purple
        case .fileSize: return .blue
        case .asciiText: return .orange
        case .permissions: return .red
        }
    }
    
    var secondaryColor: Color {
        themeColor.opacity(0.5)
    }
    
    var description: String {
        switch self {
        case .colorCoding:
            return "Learn how colors are represented using binary and hexadecimal in RGB format"
        case .fileSize:
            return "Understand how file sizes are measured and displayed in binary multiples"
        case .asciiText:
            return "Discover how text is encoded using binary through ASCII encoding"
        case .permissions:
            return "Explore how Unix file permissions are represented in binary and octal"
        }
    }
} 