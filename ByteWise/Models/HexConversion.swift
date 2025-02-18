import Foundation

struct HexConversion: Identifiable, Codable {
    var id: UUID
    let decimal: Int
    let binary: String
    let hex: String
    let points: Int
    var timestamp: Date
    
    init(decimal: Int, binary: String, hex: String, points: Int) {
        self.id = UUID()
        self.decimal = decimal
        self.binary = binary
        self.hex = hex
        self.points = points
        self.timestamp = Date()
    }
} 