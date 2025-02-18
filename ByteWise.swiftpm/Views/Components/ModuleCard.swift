import SwiftUI

struct ModuleCard: View {
    let title: String
    let description: String
    let systemImage: String
    let progress: Double
    let isLocked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: systemImage)
                        .font(.title2)
                    
                    Text(title)
                        .font(ThemeManager.headlineFont)
                    
                    Spacer()
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(ThemeManager.secondaryColor)
                    }
                }
                
                Text(description)
                    .font(ThemeManager.bodyFont)
                    .foregroundColor(ThemeManager.secondaryColor)
                
                ProgressBar(value: progress)
                    .frame(height: 4)
            }
            .padding()
            .background(ThemeManager.backgroundColor.opacity(0.7))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ThemeManager.secondaryColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isLocked)
    }
}

struct ProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(ThemeManager.secondaryColor.opacity(0.3))
                
                Rectangle()
                    .foregroundColor(ThemeManager.primaryColor)
                    .frame(width: geometry.size.width * value)
            }
        }
        .cornerRadius(2)
    }
} 