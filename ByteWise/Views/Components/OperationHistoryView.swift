import SwiftUI

struct OperationHistoryView: View {
    let entries: [OperationChallenge]
    let operation: BinaryOperation
    
    var body: some View {
        VStack(spacing: 2) {
            Text("OPERATION HISTORY")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(ThemeManager.backgroundColor.opacity(0.8))
            
            ForEach(entries) { entry in
                HStack(spacing: 15) {
                    if operation == .not {
                        Text("NOT \(entry.firstNumber)")
                    } else if operation == .shift {
                        Text("SHIFT \(entry.firstNumber)")
                    } else {
                        Text("\(entry.firstNumber) \(operation.rawValue) \(entry.secondNumber ?? 0)")
                    }
                    Text("=")
                    Text("\(entry.expectedResult)")
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