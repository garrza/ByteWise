import SwiftUI

enum ThemeManager {
    static let primaryColor = Color.green
    static let backgroundColor = Color.black
    static let secondaryColor = Color.green.opacity(0.5)
    
    static let primaryUIColor = UIColor.systemGreen
    static let backgroundUIColor = UIColor.black
    static let secondaryUIColor = UIColor.systemGreen.withAlphaComponent(0.5)
    
    static let titleFont = Font.system(.title, design: .monospaced)
    static let headlineFont = Font.system(.headline, design: .monospaced)
    static let bodyFont = Font.system(.body, design: .monospaced)
    
    static func styleButton(_ button: some View) -> some View {
        button
            .foregroundColor(.black)
            .padding()
            .background(primaryColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(secondaryColor, lineWidth: 1)
            )
    }
    
    static func styleCard(_ card: some View) -> some View {
        card
            .padding()
            .background(backgroundColor.opacity(0.7))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(secondaryColor, lineWidth: 1)
            )
            .cornerRadius(8)
    }
} 
