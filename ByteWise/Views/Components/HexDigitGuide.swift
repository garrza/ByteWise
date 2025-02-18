import SwiftUI

struct HexDigitGuide: View {
    let digits = [
        ("0", "0000"), ("1", "0001"), ("2", "0010"), ("3", "0011"),
        ("4", "0100"), ("5", "0101"), ("6", "0110"), ("7", "0111"),
        ("8", "1000"), ("9", "1001"), ("A", "1010"), ("B", "1011"),
        ("C", "1100"), ("D", "1101"), ("E", "1110"), ("F", "1111")
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("HEX DIGIT GUIDE")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 8) {
                ForEach(digits, id: \.0) { digit, binary in
                    VStack(spacing: 4) {
                        Text(digit)
                            .font(.system(.title2, design: .monospaced))
                            .foregroundColor(ThemeManager.primaryColor)
                        Text(binary)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(ThemeManager.secondaryColor)
                    }
                    .padding(8)
                    .background(ThemeManager.backgroundColor.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                }
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
} 