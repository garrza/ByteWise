import SwiftUI

struct BinaryOperationsView: View {
    @StateObject private var viewModel = BinaryOperationsViewModel()
    @EnvironmentObject private var progressManager: ProgressManager
    @State private var showingChallenge = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ThemeManager.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Operation Selection
                        VStack(spacing: 16) {
                            Text("SELECT OPERATION")
                                .font(ThemeManager.headlineFont)
                                .foregroundColor(ThemeManager.primaryColor)
                            
                            HStack(spacing: 12) {
                                ForEach(BinaryOperation.allCases, id: \.self) { operation in
                                    Button(action: { viewModel.selectedOperation = operation }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: operation.systemImage)
                                                .font(.system(size: 24))
                                            Text(operation.rawValue)
                                                .font(.system(.headline, design: .monospaced))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 100)
                                        .padding()
                                        .foregroundColor(operation == viewModel.selectedOperation ? 
                                            ThemeManager.primaryColor : ThemeManager.secondaryColor)
                                        .background(ThemeManager.backgroundColor.opacity(0.7))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(operation == viewModel.selectedOperation ? 
                                                    ThemeManager.primaryColor : ThemeManager.secondaryColor, 
                                                    lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                        )
                        
                        // Operation Explanation
                        VStack(spacing: 16) {
                            Text("EXPLANATION")
                                .font(ThemeManager.headlineFont)
                                .foregroundColor(ThemeManager.primaryColor)
                            
                            Text(viewModel.selectedOperation.explanation)
                                .font(ThemeManager.bodyFont)
                                .foregroundColor(ThemeManager.secondaryColor)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                        )
                        
                        // Binary Inputs and Result
                        VStack(spacing: 16) {
                            Text("BINARY OPERATION")
                                .font(ThemeManager.headlineFont)
                                .foregroundColor(ThemeManager.primaryColor)
                            
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
                        }
                        .padding()
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                        )
                        
                        // Challenge Section
                        if !viewModel.isChallengeActive {
                            Button(action: { showingChallenge = true }) {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("START CHALLENGE")
                                        .font(ThemeManager.headlineFont)
                                }
                            }
                            .buttonStyle(ThemeButtonStyle())
                        } else {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("SCORE: \(viewModel.score)")
                                    Spacer()
                                    Text("TIME: \(viewModel.timeRemaining)")
                                }
                                .font(ThemeManager.headlineFont)
                                .foregroundColor(ThemeManager.primaryColor)
                                
                                if let target = viewModel.targetResult {
                                    Text("Target Result: \(target)")
                                        .font(ThemeManager.bodyFont)
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
                    }
                    .padding()
                }
            }
            .navigationTitle("BINARY OPERATIONS")
            .navigationBarTitleDisplayMode(.large)
            .alert("Challenge Complete!", isPresented: $viewModel.showGameOver) {
                Button("OK") {
                    progressManager.updateProgress(
                        for: "BinaryOperations",
                        completed: true,
                        score: viewModel.score
                    )
                }
            } message: {
                Text("Final Score: \(viewModel.score)")
            }
            .navigationDestination(isPresented: $showingChallenge) {
                BinaryOperationChallengeView(operation: viewModel.selectedOperation)
            }
        }
    }
}

struct BinaryResultView: View {
    let bits: [Bool]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<8) { index in
                Text(bits[index] ? "1" : "0")
                    .font(.system(.title, design: .monospaced))
                    .frame(width: 40, height: 40)
                    .background(ThemeManager.backgroundColor)
                    .foregroundColor(ThemeManager.primaryColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
            }
        }
    }
}

struct ThemeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(ThemeManager.primaryColor)
            .foregroundColor(.black)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
} 
