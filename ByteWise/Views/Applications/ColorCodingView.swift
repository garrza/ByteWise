import SwiftUI

struct ColorCodingView: ApplicationView {
    @EnvironmentObject private var applicationsViewModel: ApplicationsViewModel
    @StateObject private var viewModel: ColorCodingViewModel
    @State private var showingAchievement = false
    
    init() {
        _viewModel = StateObject(wrappedValue: ColorCodingViewModel())
    }
    
    var score: Int { viewModel.score }
    var isCompleted: Bool { viewModel.hasCompletedChallenge }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                explanationSection
                
                colorControlSection
                
                challengeSection
            }
            .padding()
        }
        .navigationTitle("COLOR CODING")
        .navigationBarTitleDisplayMode(.large)
        .background(ThemeManager.backgroundColor.ignoresSafeArea())
        .alert("Achievement Unlocked!", isPresented: $showingAchievement) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You've become a Color Master!")
        }
        .onAppear {
            viewModel.applicationsViewModel = applicationsViewModel
        }
    }
    
    private var explanationSection: some View {
        VStack(spacing: 16) {
            Text("RGB COLOR CODING")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text("Colors in digital displays are created by mixing different amounts of Red, Green, and Blue light. Each color channel uses 8 bits (0-255) to represent its intensity.")
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
    
    private var colorControlSection: some View {
        VStack(spacing: 16) {
            Text("COLOR MIXER")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            HStack(alignment: .center, spacing: 20) {
                // Color Preview
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.color)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    Text(viewModel.hexValue)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                }
                .frame(width: 160)
                .frame(maxHeight: .infinity)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                // RGB Controls
                VStack(spacing: 12) {
                    CompactColorChannel(
                        label: "R",
                        bits: $viewModel.redBits,
                        value: viewModel.redValue,
                        color: .red
                    )
                    
                    CompactColorChannel(
                        label: "G",
                        bits: $viewModel.greenBits,
                        value: viewModel.greenValue,
                        color: .green
                    )
                    
                    CompactColorChannel(
                        label: "B",
                        bits: $viewModel.blueBits,
                        value: viewModel.blueValue,
                        color: .blue
                    )
                }
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var challengeSection: some View {
        VStack(spacing: 16) {
            Text("COLOR CHALLENGE")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            NavigationLink {
                ColorChallengeView(viewModel: viewModel)
                    .navigationTitle("COLOR CHALLENGE")
            } label: {
                Text("START CHALLENGE")
                    .buttonStyle(RetroButtonStyle())
            }
            .buttonStyle(RetroButtonStyle())
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
}

struct CompactColorChannel: View {
    let label: String
    @Binding var bits: [Bool]
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(.title2, design: .monospaced))
                    .foregroundColor(color)
                Spacer()
                Text("\(value)")
                    .font(.system(.title2, design: .monospaced))
                    .foregroundColor(ThemeManager.primaryColor)
            }
            
            HStack(spacing: 4) {
                ForEach(0..<8) { index in
                    VStack(spacing: 4) {
                        Text("\(1 << (7-index))")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(ThemeManager.secondaryColor)
                        CompactBitToggle(isOn: $bits[index])
                            .foregroundColor(color)
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct CompactBitToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            Text(isOn ? "1" : "0")
                .font(.system(.title2, design: .monospaced))
                .frame(width: 32, height: 32)
                .foregroundColor(isOn ? .black : ThemeManager.primaryColor)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isOn ? ThemeManager.primaryColor : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorMatchHistoryView: View {
    let matches: [ColorMatch]
    
    var body: some View {
        VStack(spacing: 16) {
            Text("MATCH HISTORY")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            if !matches.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(matches) { match in
                            VStack(spacing: 8) {
                                HStack(spacing: 8) {
                                    // Target color
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(match.targetColor)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                    
                                    Text("→")
                                        .foregroundColor(ThemeManager.secondaryColor)
                                    
                                    // User's color
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(match.userColor)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                                Text(match.targetHex)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(ThemeManager.secondaryColor)
                                
                                Text("+\(match.points)")
                                    .font(.system(.headline, design: .monospaced))
                                    .foregroundColor(ThemeManager.primaryColor)
                            }
                            .padding(8)
                            .background(ThemeManager.backgroundColor.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("No matches yet")
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

struct ColorChallengeView: View {
    @ObservedObject var viewModel: ColorCodingViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("MATCH THE TARGET COLOR")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.primaryColor)
                        
                        HStack(alignment: .center, spacing: 20) {
                            // RGB Controls
                            VStack(spacing: 12) {
                                CompactColorChannel(
                                    label: "R",
                                    bits: $viewModel.redBits,
                                    value: viewModel.redValue,
                                    color: .red
                                )
                                
                                CompactColorChannel(
                                    label: "G",
                                    bits: $viewModel.greenBits,
                                    value: viewModel.greenValue,
                                    color: .green
                                )
                                
                                CompactColorChannel(
                                    label: "B",
                                    bits: $viewModel.blueBits,
                                    value: viewModel.blueValue,
                                    color: .blue
                                )
                            }
                            .frame(width: 320)
                            
                            // Colors Preview
                            HStack(spacing: 16) {
                                // Target Color
                                VStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(viewModel.targetColor)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    
                                    Text("TARGET")
                                        .font(.system(.headline, design: .monospaced))
                                        .foregroundColor(ThemeManager.secondaryColor)
                                }
                                .frame(width: 140)
                                .frame(maxHeight: .infinity)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                
                                // Current Color
                                VStack(spacing: 12) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(viewModel.color)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    
                                    Text("YOUR COLOR")
                                        .font(.system(.headline, design: .monospaced))
                                        .foregroundColor(ThemeManager.secondaryColor)
                                }
                                .frame(width: 140)
                                .frame(maxHeight: .infinity)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                        }
                    }
                    .padding()
                    .background(ThemeManager.backgroundColor.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                    
                    // Add history section
                    if !viewModel.colorMatches.isEmpty {
                        ColorMatchHistoryView(matches: viewModel.colorMatches)
                    }
                    
                    // Score and Time
                    HStack {
                        Text("Score: \(viewModel.score)")
                        Spacer()
                        Text("Time: \(viewModel.timeRemaining)s")
                    }
                    .font(ThemeManager.bodyFont)
                    .foregroundColor(ThemeManager.primaryColor)
                    .padding()
                    .background(ThemeManager.backgroundColor.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                    )
                }
                .padding()
            }
            
            if viewModel.showGameOver {
                // Game Over Overlay
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("GAME OVER")
                        .font(.system(.title, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                    
                    VStack(spacing: 12) {
                        Text("FINAL SCORE")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.secondaryColor)
                        
                        Text("\(viewModel.score)")
                            .font(.system(size: 48, weight: .bold, design: .monospaced))
                            .foregroundColor(ThemeManager.primaryColor)
                    }
                    
                    if !viewModel.colorMatches.isEmpty {
                        VStack(spacing: 8) {
                            Text("MATCHES")
                                .font(ThemeManager.headlineFont)
                                .foregroundColor(ThemeManager.secondaryColor)
                            
                            Text("\(viewModel.colorMatches.count)")
                                .font(.system(.title, design: .monospaced))
                                .foregroundColor(ThemeManager.primaryColor)
                        }
                    }
                    
                    if viewModel.hasCompletedChallenge {
                        Image(systemName: "star.fill")
                            .font(.system(size: 48))
                            .foregroundColor(ThemeManager.primaryColor)
                        
                        Text("CHALLENGE COMPLETED!")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.primaryColor)
                    }
                    
                    Button(action: { dismiss() }) {
                        Text("EXIT")
                            .font(ThemeManager.headlineFont)
                    }
                    .buttonStyle(RetroButtonStyle())
                    .padding(.top)
                }
                .padding(32)
                .background(ThemeManager.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 2)
                )
                .padding(32)
            }
        }
        .background(ThemeManager.backgroundColor.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { 
                    viewModel.endChallenge()
                    dismiss() 
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("EXIT")
                    }
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(ThemeManager.primaryColor)
                }
            }
        }
        .onAppear {
            viewModel.startChallenge()
        }
        .onDisappear {
            viewModel.endChallenge()
        }
    }
} 