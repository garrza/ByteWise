import SwiftUI

struct BinaryOperationChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BinaryOperationsViewModel
    @EnvironmentObject private var progressManager: ProgressManager
    
    init(operation: BinaryOperation) {
        let viewModel = BinaryOperationsViewModel()
        viewModel.selectedOperation = operation
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Challenge Header
                VStack(spacing: 16) {
                    Text("\(viewModel.selectedOperation.rawValue) CHALLENGE")
                        .font(ThemeManager.headlineFont)
                        .foregroundColor(ThemeManager.primaryColor)
                    
                    HStack {
                        Text("SCORE: \(viewModel.score)")
                        Spacer()
                        Text("TIME: \(viewModel.timeRemaining)")
                    }
                    .font(ThemeManager.headlineFont)
                    .foregroundColor(ThemeManager.primaryColor)
                }
                .padding()
                .background(ThemeManager.backgroundColor.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
                
                HStack(spacing: 24) {
                    // Left side: Challenge
                    VStack(spacing: 24) {
                        // Target Result
                        if let target = viewModel.targetResult {
                            VStack(spacing: 8) {
                                Text("TARGET RESULT")
                                    .font(ThemeManager.bodyFont)
                                    .foregroundColor(ThemeManager.secondaryColor)
                                
                                Text("\(target)")
                                    .font(.system(.title, design: .monospaced))
                                    .foregroundColor(ThemeManager.primaryColor)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ThemeManager.backgroundColor.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                            )
                        }
                        
                        // Binary Inputs
                        VStack(spacing: 24) {
                            // First Number
                            VStack(spacing: 8) {
                                Text("FIRST NUMBER")
                                    .font(ThemeManager.bodyFont)
                                    .foregroundColor(ThemeManager.secondaryColor)
                                BinaryCounterView(bits: $viewModel.firstNumber)
                            }
                            
                            // Second Number (if needed)
                            if viewModel.selectedOperation != .not && viewModel.selectedOperation != .shift {
                                VStack(spacing: 8) {
                                    Text("SECOND NUMBER")
                                        .font(ThemeManager.bodyFont)
                                        .foregroundColor(ThemeManager.secondaryColor)
                                    BinaryCounterView(bits: $viewModel.secondNumber)
                                }
                            }
                            
                            // Result
                            VStack(spacing: 8) {
                                Text("RESULT")
                                    .font(ThemeManager.bodyFont)
                                    .foregroundColor(ThemeManager.secondaryColor)
                                BinaryResultView(bits: viewModel.result)
                            }
                        }
                        .padding()
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                        )
                    }
                    
                    // Right side: History
                    VStack(spacing: 16) {
                        Text("HISTORY")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.primaryColor)
                        
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(viewModel.scoreHistory) { entry in
                                    ScoreHistoryRow(entry: entry)
                                }
                            }
                        }
                    }
                    .frame(width: 300)
                    .padding()
                    .background(ThemeManager.backgroundColor.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startChallenge()
        }
        .alert("Challenge Complete!", isPresented: $viewModel.showGameOver) {
            Button("OK") {
                progressManager.updateProgress(
                    for: "BinaryOperations",
                    completed: true,
                    score: viewModel.score
                )
                dismiss()
            }
        } message: {
            Text("Final Score: \(viewModel.score)")
        }
    }
}

struct ScoreHistoryRow: View {
    let entry: OperationScoreEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.operation.rawValue)
                    .font(.system(.headline, design: .monospaced))
                Spacer()
                Text("+\(entry.points)")
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(ThemeManager.primaryColor)
            }
            
            if let second = entry.secondNumber {
                Text("\(entry.firstNumber) \(entry.operation.rawValue) \(second) = \(entry.result)")
                    .font(.system(.caption, design: .monospaced))
            } else {
                Text("\(entry.operation.rawValue) \(entry.firstNumber) = \(entry.result)")
                    .font(.system(.caption, design: .monospaced))
            }
        }
        .padding(8)
        .background(ThemeManager.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
} 