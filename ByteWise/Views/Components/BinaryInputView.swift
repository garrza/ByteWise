import SwiftUI

struct BinaryInputView: View {
    let title: String
    @Binding var bits: [Bool]
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
                    BitToggleButton(isOn: $bits[index], position: index)
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
