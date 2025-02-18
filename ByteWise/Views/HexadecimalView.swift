import SwiftUI

struct HexadecimalRulesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("HEXADECIMAL RULES")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            VStack(alignment: .leading, spacing: 12) {
                RuleItem(
                    title: "Base-16 System",
                    description: "Hexadecimal uses 16 digits: 0-9 and A-F, where A=10, B=11, C=12, D=13, E=14, F=15"
                )
                
                RuleItem(
                    title: "Byte Representation",
                    description: "One byte (8 bits) can be represented by two hexadecimal digits (00-FF)"
                )
                
                RuleItem(
                    title: "Common Prefixes",
                    description: "Hex numbers are often prefixed with '0x' (programming) or '#' (colors)"
                )
                
                RuleItem(
                    title: "Position Values",
                    description: "Each position represents a power of 16 (16⁰, 16¹, 16², etc.)"
                )
                
                RuleItem(
                    title: "Binary Conversion",
                    description: "Each hex digit represents exactly 4 binary digits (nibble)"
                )
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

struct RuleItem: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor)
            
            Text(description)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(ThemeManager.secondaryColor)
        }
    }
}

struct HexadecimalView: View {
    @StateObject private var viewModel = HexadecimalViewModel()
    @EnvironmentObject private var progressManager: ProgressManager
    @State private var showingChallenge = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Explanation Card
                    VStack(spacing: 16) {
                        Text("HEXADECIMAL SYSTEM")
                            .font(ThemeManager.headlineFont)
                            .foregroundColor(ThemeManager.primaryColor)
                        
                        Text("Hexadecimal is a base-16 number system using digits 0-9 and letters A-F. Each hex digit represents 4 binary digits (bits), making it a convenient way to represent binary numbers.")
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
                    
                    // Hex Guide
                    HexDigitGuide()
                    
                    // Interactive Converter and Rules side by side
                    HStack(spacing: 24) {
                        // Interactive Converter
                        VStack(spacing: 16) {
                            Text("HEXADECIMAL PLAYGROUND")
                                .font(ThemeManager.headlineFont)
                                .foregroundColor(ThemeManager.primaryColor)
                            
                            // Hex Input
                            VStack(spacing: 32) {  // Increased spacing between main sections
                                // Hex Input Section
                                VStack(spacing: 8) {
                                    Text("HEX INPUT")
                                        .font(.system(.title3, design: .monospaced))
                                        .foregroundColor(ThemeManager.secondaryColor)
                                    
                                    TextField("00", text: $viewModel.hexInput)
                                        .textFieldStyle(.plain)
                                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                                        .foregroundColor(ThemeManager.primaryColor)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 120, height: 60)
                                        .textCase(.uppercase)
                                        .keyboardType(.asciiCapable)
                                        .onChange(of: viewModel.hexInput) { _ in
                                            viewModel.updateFromHex()
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(ThemeManager.primaryColor, lineWidth: 2)
                                        )
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Binary Representation
                                VStack(spacing: 16) {
                                    Text("BINARY REPRESENTATION")
                                        .font(.system(.title3, design: .monospaced))
                                        .foregroundColor(ThemeManager.secondaryColor)
                                    
                                    // Binary digits
                                    HexBinaryCounterView(bits: $viewModel.playgroundBits)
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Decimal Value
                                VStack(spacing: 12) {
                                    Text("DECIMAL VALUE")
                                        .font(.system(.title3, design: .monospaced))
                                        .foregroundColor(ThemeManager.secondaryColor)
                                    
                                    Text("\(viewModel.decimalValue)")
                                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                                        .foregroundColor(ThemeManager.primaryColor)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 24)
                            .background(ThemeManager.backgroundColor.opacity(0.7))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                            )
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                        )
                        
                        // Rules
                        VStack(spacing: 16) {
                            Text("HEXADECIMAL RULES")
                                .font(ThemeManager.headlineFont)
                                .foregroundColor(ThemeManager.primaryColor)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                RuleItem(
                                    title: "Base-16 System",
                                    description: "Hexadecimal uses 16 digits: 0-9 and A-F, where A=10, B=11, C=12, D=13, E=14, F=15"
                                )
                                
                                RuleItem(
                                    title: "Byte Representation",
                                    description: "One byte (8 bits) can be represented by two hexadecimal digits (00-FF)"
                                )
                                
                                RuleItem(
                                    title: "Common Prefixes",
                                    description: "Hex numbers are often prefixed with '0x' (programming) or '#' (colors)"
                                )
                                
                                RuleItem(
                                    title: "Position Values",
                                    description: "Each position represents a power of 16 (16⁰, 16¹, 16², etc.)"
                                )
                                
                                RuleItem(
                                    title: "Binary Conversion",
                                    description: "Each hex digit represents exactly 4 binary digits (nibble)"
                                )
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                        )
                    }
                    .frame(height: 600) // Fixed height for both sections
                    
                    // Challenge Button
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
            .navigationTitle("HEXADECIMAL")
            .navigationBarTitleDisplayMode(.large)
            .background(ThemeManager.backgroundColor.ignoresSafeArea())
            .sheet(isPresented: $showingChallenge) {
                HexadecimalChallengeView(viewModel: viewModel)
            }
        }
        .onChange(of: viewModel.score) { newScore in
            progressManager.updateProgress(
                for: "Hexadecimal",
                completed: newScore >= 1000,
                score: newScore
            )
        }
    }
}

struct HexBinaryCounterView: View {
    @Binding var bits: [Bool]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<8, id: \.self) { index in
                VStack(spacing: 8) {
                    Text(bits[index] ? "1" : "0")
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                        .frame(width: 60, height: 60)
                        .background(ThemeManager.backgroundColor.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(ThemeManager.secondaryColor, lineWidth: 2)
                        )
                    
                    // Power of 2
                    Text("2^\(7-index)")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(ThemeManager.secondaryColor)
                    
                    // Value
                    Text("\(1 << (7-index))")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(bits[index] ? ThemeManager.primaryColor : ThemeManager.secondaryColor)
                }
            }
        }
    }
} 