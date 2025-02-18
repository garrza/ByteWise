import SwiftUI
import Foundation

struct ColorMatch: Identifiable {
    let id = UUID()
    let targetColor: Color
    let userColor: Color
    let targetHex: String
    let userHex: String
    let points: Int
    let timestamp = Date()
} 