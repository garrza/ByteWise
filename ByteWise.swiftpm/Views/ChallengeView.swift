import SwiftUI

struct ChallengeView: View {
    let targetNumber: Int
    let currentValue: Int
    let timeRemaining: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("CONVERT TO BINARY")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(ThemeManager.backgroundColor.opacity(0.8))
            
            Text("\(targetNumber)")
                .font(.system(size: 56, weight: .bold, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor)
            
            if currentValue == targetNumber {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("CORRECT - NEXT NUMBER LOADING...")
                }
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.primaryColor)
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
        .cornerRadius(8)
    }
} 