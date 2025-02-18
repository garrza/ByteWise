import SwiftUI

struct BinaryBasicsView: View {
    @StateObject private var viewModel = BinaryBasicsViewModel()
    @State private var showingChallenge = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Introduction Section
                    IntroductionSection()
                    
                    // Interactive Binary Section
                    VStack(spacing: 16) {
                        Text("BINARY PLAYGROUND")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.primaryColor)
                        
                        // Place Values Display
                        VStack(spacing: 8) {
                            HStack {
                                ForEach(0..<8) { index in
                                    Text("2^\(7-index)")
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(ThemeManager.secondaryColor)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            HStack {
                                ForEach(0..<8) { index in
                                    Text("\(1 << (7-index))")
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundColor(viewModel.bits[index] ? ThemeManager.primaryColor : ThemeManager.secondaryColor)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Binary Input
                        BinaryCounterView(bits: $viewModel.bits)
                            .padding(.horizontal)
                        
                        // Decimal Result
                        HStack {
                            Text("DECIMAL VALUE:")
                                .foregroundColor(ThemeManager.secondaryColor)
                            Text("\(viewModel.decimalValue)")
                                .foregroundColor(ThemeManager.primaryColor)
                                .font(.system(.title, design: .monospaced))
                        }
                        .padding(.vertical, 8)
                    }
                    .padding()
                    .background(ThemeManager.backgroundColor.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                    
                    // Binary Rules Section
                    VStack(spacing: 16) {
                        Text("BINARY RULES")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.primaryColor)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            RuleCard(
                                title: "PLACE VALUES",
                                text: "Each position represents a power of 2",
                                example: "128, 64, 32, 16, 8, 4, 2, 1"
                            )
                            
                            RuleCard(
                                title: "BIT STATES",
                                text: "Each bit can only be 0 or 1",
                                example: "0 = OFF, 1 = ON"
                            )
                            
                            RuleCard(
                                title: "CONVERSION",
                                text: "To convert to decimal, sum the place values of all 1s",
                                example: "1001 = 8 + 1 = 9"
                            )
                            
                            RuleCard(
                                title: "BYTE RANGE",
                                text: "8 bits (a byte) can represent values from 0 to 255",
                                example: "00000000 to 11111111"
                            )
                        }
                    }
                    .padding()
                    .background(ThemeManager.backgroundColor.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                    
                    // Practice Button
                    Button(action: { showingChallenge = true }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("START CHALLENGE")
                                .font(ThemeManager.headlineFont)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ThemeManager.primaryColor)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("BINARY BASICS")
            .navigationBarTitleDisplayMode(.large)
            .background(ThemeManager.backgroundColor.ignoresSafeArea())
            .sheet(isPresented: $showingChallenge) {
                BinaryChallengeView(viewModel: viewModel)
            }
        }
    }
}

private struct IntroductionSection: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("WHAT IS BINARY?")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text("Binary is a base-2 number system that uses only two digits: 0 and 1. Each digit is called a bit (binary digit). Computers use binary because electronic circuits can easily represent two states: on (1) or off (0).")
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
    }
}

struct BinaryCounterView: View {
    @Binding var bits: [Bool]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("BINARY INPUT")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(ThemeManager.backgroundColor.opacity(0.8))
            
            HStack(spacing: 12) {
                ForEach(0..<8, id: \.self) { index in
                    BitToggleButton(isOn: $bits[index], position: index)
                }
            }
            .padding()
            .background(ThemeManager.backgroundColor.opacity(0.7))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
        .cornerRadius(8)
    }
}

struct RetroGameOverView: View {
    let score: Int
    let streak: Int
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(ThemeManager.primaryColor)
                
                Text("CHALLENGE COMPLETE!")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
            }
            
            // Stats Section
            HStack(spacing: 16) {
                // Score with circular progress
                ZStack {
                    Circle()
                        .stroke(ThemeManager.secondaryColor, lineWidth: 4)
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .trim(from: 0, to: min(CGFloat(score) / 1000, 1))
                        .stroke(ThemeManager.primaryColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Text("\(score)")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                        Text("SCORE")
                            .font(.system(.caption2, design: .monospaced))
                    }
                }
                
                // Streak badge
                VStack(spacing: 0) {
                    Text("\(streak)")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                    Text("STREAK")
                        .font(.system(.caption2, design: .monospaced))
                }
                .padding(.vertical, 6)
                .frame(width: 70)
                .background(ThemeManager.backgroundColor.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
            }
            
            if score >= 1000 {
                Label("MASTERY ACHIEVED", systemImage: "star.fill")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(ThemeManager.primaryColor)
            } else {
                Text("\(1000 - score) points to mastery")
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(ThemeManager.secondaryColor)
            }
            
            // Feedback message
            Text(feedbackMessage)
                .font(.system(.caption2, design: .monospaced))
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)
            
            // Exit button
            Button(action: onDismiss) {
                Text("EXIT")
                    .font(.system(.subheadline, design: .monospaced))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(ThemeManager.primaryColor)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(
            ThemeManager.backgroundColor
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ThemeManager.primaryColor, lineWidth: 2)
                )
        )
        .cornerRadius(12)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(ThemeManager.backgroundColor.opacity(0.9))
    }
    
    private var feedbackMessage: String {
        if score >= 1000 {
            return "Outstanding! You've mastered binary numbers. Ready to tackle more challenges?"
        } else if score >= 750 {
            return "Excellent progress! You're very close to achieving mastery."
        } else if score >= 500 {
            return "Great work! Keep practicing to improve your binary skills."
        } else if score >= 250 {
            return "Good start! Practice more to build your confidence."
        } else {
            return "Keep practicing! Binary conversion gets easier with time."
        }
    }
} 
