import SwiftUI

struct BinaryOperationView: View {
    @StateObject private var viewModel = BinaryOperationsViewModel()
    @EnvironmentObject private var progressManager: ProgressManager
    let operation: BinaryOperation
    
    var body: some View {
        ZStack {
            ThemeManager.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isChallengeActive {
                        challengeView
                    } else {
                        practiceView
                    }
                }
                .padding()
            }
        }
        .navigationTitle(operation.rawValue)
        .onAppear {
            viewModel.selectedOperation = operation
        }
        .onChange(of: viewModel.score) { newScore in
            progressManager.updateProgress(
                for: "BinaryOps_\(operation.rawValue)",
                completed: newScore >= 1000,
                score: newScore
            )
        }
        .overlay {
            if viewModel.showGameOver {
                RetroGameOverView(
                    score: viewModel.score,
                    streak: viewModel.consecutiveCorrect
                ) {
                    viewModel.showGameOver = false
                    viewModel.isChallengeActive = false
                }
            }
        }
    }
    
    private var practiceView: some View {
        VStack(spacing: 24) {
            OperationExplanationView(operation: operation)
            
            // First Number
            BinaryInputView(
                title: "FIRST NUMBER",
                bits: $viewModel.firstNumber,
                decimal: viewModel.firstDecimal
            )
            
            // Second Number (if needed)
            if operation != .not && operation != .shift {
                BinaryInputView(
                    title: "SECOND NUMBER",
                    bits: $viewModel.secondNumber,
                    decimal: viewModel.secondDecimal
                )
            }
            
            // Operation Button
            Button(action: viewModel.performOperation) {
                Text("PERFORM \(operation.rawValue)")
                    .font(ThemeManager.headlineFont)
            }
            .buttonStyle(RetroButtonStyle())
            
            // Result
            BinaryDisplayView(
                title: "RESULT",
                bits: viewModel.result,
                decimal: viewModel.resultDecimal
            )
            
            Spacer()
            
            // Challenge Button
            Button(action: viewModel.startChallenge) {
                Text("START CHALLENGE")
                    .font(ThemeManager.headlineFont)
            }
            .buttonStyle(RetroButtonStyle())
        }
    }
    
    private var challengeView: some View {
        VStack(spacing: 20) {
            // Challenge Stats
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SCORE: \(viewModel.score)")
                        .font(ThemeManager.headlineFont)
                    Text("STREAK: \(viewModel.consecutiveCorrect)")
                        .font(ThemeManager.bodyFont)
                }
                Spacer()
                Text("TIME: \(viewModel.timeRemaining)s")
                    .font(ThemeManager.headlineFont)
                    .foregroundColor(viewModel.timeRemaining < 10 ? .red : ThemeManager.primaryColor)
            }
            .foregroundColor(ThemeManager.primaryColor)
            .padding()
            .background(ThemeManager.backgroundColor.opacity(0.7))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ThemeManager.secondaryColor, lineWidth: 1)
            )
            
            if !viewModel.challengeHistory.isEmpty {
                OperationHistoryView(entries: viewModel.challengeHistory, operation: operation)
                    .frame(height: 200)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Target Result
            VStack(spacing: 8) {
                Text("TARGET RESULT")
                    .font(ThemeManager.headlineFont)
                Text(String(describing: viewModel.targetResult ?? 0))
                    .font(.system(.title, design: .monospaced))
            }
            .foregroundColor(ThemeManager.primaryColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(ThemeManager.backgroundColor.opacity(0.7))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ThemeManager.secondaryColor, lineWidth: 1)
            )
            
            // Operation Components
            if operation != .not && operation != .shift {
                BinaryDisplayView(
                    title: "FIRST NUMBER",
                    bits: viewModel.firstNumber,
                    decimal: viewModel.firstDecimal
                )
                
                BinaryInputView(
                    title: "SECOND NUMBER",
                    bits: $viewModel.secondNumber,
                    decimal: viewModel.secondDecimal
                )
            } else {
                BinaryInputView(
                    title: "INPUT NUMBER",
                    bits: $viewModel.firstNumber,
                    decimal: viewModel.firstDecimal
                )
            }
            
            Button(action: viewModel.performOperation) {
                Text("CALCULATE")
                    .font(ThemeManager.headlineFont)
            }
            .buttonStyle(RetroButtonStyle())
        }
    }
}

struct RetroButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? ThemeManager.backgroundColor : ThemeManager.primaryColor)
            .padding()
            .background(
                configuration.isPressed ? ThemeManager.primaryColor : ThemeManager.backgroundColor
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ThemeManager.primaryColor, lineWidth: 1)
            )
    }
} 