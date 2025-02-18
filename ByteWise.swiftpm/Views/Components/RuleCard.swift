import SwiftUI

struct RuleCard: View {
    let title: String
    let text: String
    let example: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor)
            
            Text(text)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(ThemeManager.secondaryColor)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Example:")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor.opacity(0.7))
            
            Text(example)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(ThemeManager.backgroundColor.opacity(0.8))
                .cornerRadius(4)
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.5))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
} 