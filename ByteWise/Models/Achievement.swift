import Foundation

struct Achievement: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let requiredScore: Int
    
    static let colorMaster = Achievement(
        id: "color_master",
        title: "Color Master",
        description: "Master RGB color coding",
        icon: "paintpalette.fill",
        requiredScore: 500
    )
    
    static let sizeExpert = Achievement(
        id: "size_expert",
        title: "Size Expert",
        description: "Expert in binary file sizes",
        icon: "internaldrive.fill",
        requiredScore: 750
    )
    
    static let asciiGuru = Achievement(
        id: "ascii_guru",
        title: "ASCII Guru",
        description: "Master of ASCII encoding",
        icon: "character.textbox",
        requiredScore: 600
    )
    
    static let permissionPro = Achievement(
        id: "permission_pro",
        title: "Permission Pro",
        description: "Expert in file permissions",
        icon: "lock.shield.fill",
        requiredScore: 800
    )
    
    static func forApplication(_ application: BinaryApplication) -> Achievement {
        switch application {
        case .colorCoding: return colorMaster
        case .fileSize: return sizeExpert
        case .asciiText: return asciiGuru
        case .permissions: return permissionPro
        }
    }
} 