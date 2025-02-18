import SwiftUI

struct OperationExplanationView: View {
    let operation: BinaryOperation
    
    var body: some View {
        VStack(spacing: 16) {
            Text("HOW IT WORKS")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text(operation.explanation)
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(ThemeManager.backgroundColor.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
            
            // Truth table for binary operations
            if operation != .shift {
                VStack(spacing: 8) {
                    Text("TRUTH TABLE")
                        .font(ThemeManager.headlineFont)
                        .foregroundColor(ThemeManager.primaryColor)
                    
                    TruthTableView(operation: operation)
                }
            }
        }
        .padding()
    }
}

struct TruthTableView: View {
    let operation: BinaryOperation
    
    var body: some View {
        VStack(spacing: 4) {
            // Header
            HStack {
                if operation != .not {
                    Text("A")
                    Text("B")
                } else {
                    Text("IN")
                }
                Text("OUT")
            }
            .font(ThemeManager.bodyFont.bold())
            .foregroundColor(ThemeManager.primaryColor)
            
            // Rows
            ForEach(0..<(operation == .not ? 2 : 4), id: \.self) { index in
                HStack {
                    if operation != .not {
                        Text("\(index >> 1)")
                        Text("\(index & 1)")
                    } else {
                        Text("\(index)")
                    }
                    Text("\(resultFor(index))")
                }
                .font(ThemeManager.bodyFont.monospaced())
                .foregroundColor(ThemeManager.secondaryColor)
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private func resultFor(_ index: Int) -> String {
        switch operation {
        case .and:
            return "\((index >> 1) & (index & 1))"
        case .or:
            return "\((index >> 1) | (index & 1))"
        case .xor:
            return "\((index >> 1) ^ (index & 1))"
        case .not:
            return "\(1 - index)"
        case .shift:
            return ""
        }
    }
} 