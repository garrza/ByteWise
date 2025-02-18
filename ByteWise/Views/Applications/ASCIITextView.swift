import SwiftUI

struct ASCIITextView: View, ApplicationView {
    @StateObject var viewModel = ASCIITextViewModel()
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var applicationsViewModel: ApplicationsViewModel
    
    // Required ApplicationView protocol properties
    var score: Int { viewModel.score }
    var isCompleted: Bool { viewModel.hasCompletedChallenge }
    
    var title: String { "ASCII TEXT" }
    var systemImage: String { "character.textbox" }
    var description: String { "Learn how text is encoded using ASCII" }
    var application: BinaryApplication { .asciiText }
    
    // Required by ApplicationView protocol
    func updateProgress(score: Int) {
        progressManager.updateProgress(
            for: "App_\(application.rawValue)",
            completed: true,
            score: score
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.isChallengeActive {
                    challengeView
                } else {
                    // Introduction Section
                    introductionSection
                    
                    // Interactive ASCII Converter
                    asciiConverterSection
                    
                    // ASCII Categories
                    asciiCategoriesSection
                    
                    // ASCII Rules
                    asciiRulesSection
                    
                    // Challenge Button
                    startChallengeButton
                }
            }
            .padding()
        }
        .background(ThemeManager.backgroundColor.ignoresSafeArea())
        .navigationTitle("ASCII TEXT")
        .onAppear {
            viewModel.setApplicationsViewModel(applicationsViewModel)
            viewModel.updateBitsFromCharacter()
        }
        .onDisappear {
            viewModel.cleanup()
        }
    }
    
    private var introductionSection: some View {
        VStack(spacing: 16) {
            Text("WHAT IS ASCII?")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text("ASCII (American Standard Code for Information Interchange) is a character encoding standard that represents text characters as numbers. Each character is assigned a unique number from 0 to 127, which can be represented in binary.")
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(ThemeManager.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var asciiConverterSection: some View {
        VStack(spacing: 16) {
            Text("ASCII CONVERTER")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            HStack(spacing: 32) {
                // Character Input
                VStack(spacing: 8) {
                    Text("CHARACTER")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(ThemeManager.secondaryColor)
                    
                    TextField("A", text: $viewModel.text)
                        .textFieldStyle(.plain)
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                        .multilineTextAlignment(.center)
                        .frame(width: 80, height: 80)
                        .onChange(of: viewModel.text) { newValue in
                            if newValue.count > 1 {
                                viewModel.text = String(newValue.prefix(1))
                            }
                            viewModel.updateBitsFromCharacter()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ThemeManager.primaryColor, lineWidth: 2)
                        )
                        .placeholder(when: viewModel.text.isEmpty) {
                            Text("A")
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(ThemeManager.secondaryColor.opacity(0.5))
                        }
                }
                
                // ASCII Value
                VStack(spacing: 8) {
                    Text("ASCII VALUE")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(ThemeManager.secondaryColor)
                    
                    Text("\(viewModel.currentAsciiValue ?? 0)")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                        )
                }
                
                // Binary Value
                VStack(spacing: 8) {
                    Text("BINARY")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(ThemeManager.secondaryColor)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<8, id: \.self) { index in
                            BitCell(value: viewModel.bits[index], position: index)
                        }
                    }
                }
            }
            .padding()
            .background(ThemeManager.backgroundColor)
            .cornerRadius(8)
        }
        .padding()
        .background(ThemeManager.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var asciiCategoriesSection: some View {
        VStack(spacing: 16) {
            Text("ASCII CATEGORIES")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                CategoryCard(range: "0-31", title: "Control Chars", description: "Non-printable control characters")
                CategoryCard(range: "32-47", title: "Punctuation", description: "Space, !, \", #, $, etc.")
                CategoryCard(range: "48-57", title: "Numbers", description: "Digits 0-9")
                CategoryCard(range: "58-64", title: "Symbols", description: "::, ;, <, =, >, ?, @")
                CategoryCard(range: "65-90", title: "Uppercase", description: "A-Z")
                CategoryCard(range: "91-96", title: "More Symbols", description: "[, \\, ], ^, _, `")
                CategoryCard(range: "97-122", title: "Lowercase", description: "a-z")
                CategoryCard(range: "123-127", title: "Special Chars", description: "{, |, }, ~, DEL")
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var asciiRulesSection: some View {
        VStack(spacing: 16) {
            Text("ASCII RULES")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                RuleCard(
                    title: "7-BIT ENCODING",
                    text: "ASCII uses 7 bits, allowing 128 unique characters",
                    example: "Range: 0-127"
                )
                
                RuleCard(
                    title: "CASE CONVERSION",
                    text: "Toggle case by flipping the 6th bit (±32)",
                    example: "A(65) ↔ a(97)"
                )
                
                RuleCard(
                    title: "DIGIT ENCODING",
                    text: "Digits start at 48 (ASCII '0')",
                    example: "'0'+n = digit n"
                )
                
                RuleCard(
                    title: "PRINTABLE RANGE",
                    text: "Visible characters start at space (32)",
                    example: "32-126 visible"
                )
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var startChallengeButton: some View {
        Button(action: { viewModel.startChallenge() }) {
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
    
    private var challengeView: some View {
        ZStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Text("ASCII CHALLENGE")
                        .font(ThemeManager.headlineFont)
                        .foregroundColor(ThemeManager.primaryColor)
                    
                    Text("Convert the ASCII value to its character")
                        .font(ThemeManager.bodyFont)
                        .foregroundColor(ThemeManager.secondaryColor)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(ThemeManager.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
                
                // Challenge Stats
                HStack(spacing: 24) {
                    // Timer
                    VStack {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 24))
                        Text("\(viewModel.timeRemaining)s")
                            .font(.system(.title3, design: .monospaced))
                    }
                    .foregroundColor(ThemeManager.primaryColor)
                    
                    // Score
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                        Text("\(viewModel.score)")
                            .font(.system(.title3, design: .monospaced))
                    }
                    .foregroundColor(ThemeManager.primaryColor)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(ThemeManager.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
                
                // Conversion History
                if !viewModel.conversionHistory.isEmpty {
                    VStack(spacing: 8) {
                        Text("CONVERSION HISTORY")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.primaryColor)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.conversionHistory) { entry in
                                    VStack(spacing: 4) {
                                        Text(entry.character)
                                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                                            .foregroundColor(ThemeManager.primaryColor)
                                        Text("\(entry.asciiValue)")
                                            .font(.system(.subheadline, design: .monospaced))
                                        Text(entry.binary)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(ThemeManager.secondaryColor)
                                        Text("+\(entry.points)")
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(ThemeManager.primaryColor)
                                    }
                                    .padding()
                                    .background(ThemeManager.backgroundColor)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ThemeManager.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                }
                
                // ASCII Conversion Challenge
                VStack(spacing: 16) {
                    Text("CONVERT TO CHARACTER")
                        .font(ThemeManager.headlineFont)
                        .foregroundColor(ThemeManager.primaryColor)
                    
                    HStack(spacing: 32) {
                        // ASCII Value Display
                        VStack(spacing: 8) {
                            Text("ASCII VALUE")
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(ThemeManager.secondaryColor)
                            
                            Text("\(Int(viewModel.targetCharacter?.asciiValue ?? 0))")
                                .font(.system(size: 32, weight: .bold, design: .monospaced))
                                .foregroundColor(ThemeManager.primaryColor)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                                )
                        }
                        
                        // Binary Display
                        VStack(spacing: 8) {
                            Text("BINARY")
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(ThemeManager.secondaryColor)
                            
                            HStack(spacing: 4) {
                                ForEach(0..<8, id: \.self) { index in
                                    BitCell(value: viewModel.challengeBits[index], position: index)
                                }
                            }
                        }
                        
                        // Character Input
                        VStack(spacing: 8) {
                            Text("CHARACTER")
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundColor(ThemeManager.secondaryColor)
                            
                            TextField("?", text: $viewModel.challengeInput)
                                .textFieldStyle(.plain)
                                .font(.system(size: 48, weight: .bold, design: .monospaced))
                                .foregroundColor(ThemeManager.primaryColor)
                                .multilineTextAlignment(.center)
                                .frame(width: 80, height: 80)
                                .onChange(of: viewModel.challengeInput) { newValue in
                                    if newValue.count > 1 {
                                        viewModel.challengeInput = String(newValue.prefix(1))
                                    }
                                    viewModel.checkChallengeAnswer()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(ThemeManager.primaryColor, lineWidth: 2)
                                )
                                .placeholder(when: viewModel.challengeInput.isEmpty) {
                                    Text("?")
                                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                                        .foregroundColor(ThemeManager.secondaryColor.opacity(0.5))
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(ThemeManager.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
                
                if viewModel.hasCompletedChallenge {
                    Button(action: { viewModel.isChallengeActive = false }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("CHALLENGE COMPLETED")
                                .font(ThemeManager.headlineFont)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ThemeManager.primaryColor)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            .background(ThemeManager.backgroundColor)
            
            // Game Over Overlay
            if viewModel.showGameOver {
                RetroGameOverView(
                    score: viewModel.score,
                    streak: viewModel.conversionHistory.count,
                    onDismiss: {
                        viewModel.exitChallenge()
                    }
                )
            }
        }
    }
    
    private struct RetroGameOverView: View {
        let score: Int
        let streak: Int
        let onDismiss: () -> Void
        
        var body: some View {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "flag.checkered.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(ThemeManager.primaryColor)
                    
                    Text("CHALLENGE COMPLETE!")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                }
                
                // Stats Section
                HStack(spacing: 32) {
                    // Score with circular progress
                    ZStack {
                        Circle()
                            .stroke(ThemeManager.secondaryColor, lineWidth: 4)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: min(CGFloat(score) / 600, 1))
                            .stroke(ThemeManager.primaryColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 4) {
                            Text("\(score)")
                                .font(.system(size: 32, weight: .bold, design: .monospaced))
                            Text("SCORE")
                                .font(.system(.title3, design: .monospaced))
                        }
                    }
                    
                    // Conversion streak
                    VStack(spacing: 4) {
                        Text("\(streak)")
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                        Text("STREAK")
                            .font(.system(.title3, design: .monospaced))
                    }
                    .padding(.vertical, 12)
                    .frame(width: 120)
                    .background(ThemeManager.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                }
                .padding(.vertical, 16)
                
                if score >= 600 {
                    Label("ASCII GURU", systemImage: "star.fill")
                        .font(.system(.title2, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                } else {
                    Text("\(600 - score) points to mastery")
                        .font(.system(.title3, design: .monospaced))
                        .foregroundColor(ThemeManager.secondaryColor)
                }
                
                // Feedback message
                Text(feedbackMessage)
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(ThemeManager.secondaryColor)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                
                // Exit button
                Button(action: onDismiss) {
                    Text("EXIT")
                        .font(.system(.title3, design: .monospaced))
                        .padding(.horizontal, 48)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(ThemeManager.primaryColor)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
            .padding(32)
            .background(
                ThemeManager.backgroundColor
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ThemeManager.primaryColor, lineWidth: 2)
                    )
            )
            .cornerRadius(16)
            .frame(maxWidth: 500)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ThemeManager.backgroundColor.opacity(0.9))
        }
        
        private var feedbackMessage: String {
            if score >= 600 {
                return "Outstanding! You've mastered ASCII encoding. Ready for more challenges?"
            } else if score >= 400 {
                return "Excellent progress! You're very close to achieving ASCII mastery."
            } else if score >= 200 {
                return "Great work! Keep practicing to improve your ASCII skills."
            } else {
                return "Keep practicing! ASCII conversion gets easier with time."
            }
        }
    }
}

struct CategoryCard: View {
    let range: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(range)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor)
            
            Text(title)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor)
            
            Text(description)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(ThemeManager.secondaryColor)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(ThemeManager.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
