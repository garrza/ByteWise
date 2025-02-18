import Foundation

enum FileSizeUnit: String, CaseIterable {
    case byte = "B"
    case kibibyte = "KiB"
    case mebibyte = "MiB"
    case gibibyte = "GiB"
    case tebibyte = "TiB"
    
    var multiplier: UInt64 {
        switch self {
        case .byte: return 1
        case .kibibyte: return 1024
        case .mebibyte: return 1024 * 1024
        case .gibibyte: return 1024 * 1024 * 1024
        case .tebibyte: return 1024 * 1024 * 1024 * 1024
        }
    }
    
    var explanation: String {
        switch self {
        case .byte:
            return "1 byte = 8 bits"
        case .kibibyte:
            return "1 KiB = 1,024 bytes (2¹⁰)"
        case .mebibyte:
            return "1 MiB = 1,024 KiB (2²⁰)"
        case .gibibyte:
            return "1 GiB = 1,024 MiB (2³⁰)"
        case .tebibyte:
            return "1 TiB = 1,024 GiB (2⁴⁰)"
        }
    }
} 