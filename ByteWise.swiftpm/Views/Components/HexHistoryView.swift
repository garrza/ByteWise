import SwiftUI

struct HexHistoryView: View {
    let entries: [HexConversion]
    
    var body: some View {
        VStack(spacing: 2) {
            Text("CONVERSION HISTORY")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(ThemeManager.backgroundColor.opacity(0.8))
            
            ForEach(entries) { entry in
                HStack(spacing: 15) {
                    Text("\(entry.decimal)")
                        .frame(width: 40, alignment: .trailing)
                    Text("=")
                    Text(entry.binary)
                    Text("=")
                    Text(entry.hex)
                        .foregroundColor(ThemeManager.primaryColor)
                    Spacer()
                    Text("+\(entry.points)")
                        .foregroundColor(ThemeManager.primaryColor)
                }
                .font(ThemeManager.bodyFont)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
            }
        }
        .foregroundColor(ThemeManager.secondaryColor)
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
        .cornerRadius(8)
    }
} 