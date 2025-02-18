import SwiftUI

struct BinaryDisplayView: View {
    let title: String
    let bits: [Bool]
    let decimal: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .background(ThemeManager.backgroundColor.opacity(0.8))
            
            HStack(spacing: 12) {
                ForEach(0..<8, id: \.self) { index in
                    BitCell(value: bits[index], position: index)
                }
            }
            .padding()
            
            Text("DECIMAL: \(decimal)")
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.primaryColor)
        }
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
}

struct BitCell: View {
    let value: Bool
    let position: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value ? "1" : "0")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .frame(width: 40, height: 40)
                .background(
                    ZStack {
                        ThemeManager.backgroundColor
                        if value {
                            ThemeManager.primaryColor.opacity(0.3)
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(value ? ThemeManager.primaryColor : ThemeManager.secondaryColor,
                               lineWidth: value ? 2 : 0.5)
                )
            
            Text("2^\(7-position)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(ThemeManager.secondaryColor)
        }
    }
} 