import SwiftUI

struct BinaryChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BinaryBasicsViewModel
    @EnvironmentObject private var progressManager: ProgressManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                ThemeManager.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Game Stats
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
                    
                    // Score History
                    if !viewModel.scoreHistory.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.scoreHistory) { entry in
                                    VStack(spacing: 4) {
                                        Text("\(entry.decimal)")
                                            .font(.system(.title2, design: .monospaced))
                                        Text(entry.binary)
                                            .font(.system(.caption, design: .monospaced))
                                        Text("+\(entry.points)")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(.green)
                                    }
                                    .padding()
                                    .background(ThemeManager.backgroundColor.opacity(0.7))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Target Number
                    VStack(spacing: 8) {
                        Text("CONVERT TO BINARY:")
                            .font(ThemeManager.headlineFont)
                        Text("\(viewModel.targetNumber)")
                            .font(.system(size: 46, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(ThemeManager.primaryColor)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ThemeManager.backgroundColor.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                    
                    // Binary Input
                    BinaryCounterView(bits: $viewModel.bits)
                }
                .padding()
                
                // Game Over Overlay
                if viewModel.showGameOver {
                    RetroGameOverView(
                        score: viewModel.score,
                        streak: viewModel.consecutiveCorrect
                    ) {
                        viewModel.resetGame()
                        dismiss()
                    }
                }
            }
            .navigationTitle("BINARY CHALLENGE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("EXIT") {
                        viewModel.resetGame()
                        dismiss()
                    }
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(ThemeManager.primaryColor)
                }
            }
            .onAppear {
                viewModel.startChallenge()
            }
            .onDisappear {
                viewModel.resetGame()
            }
            .onChange(of: viewModel.score) { newScore in
                progressManager.updateProgress(
                    for: "BinaryBasics",
                    completed: newScore >= 1000,
                    score: newScore
                )
            }
        }
    }
} 