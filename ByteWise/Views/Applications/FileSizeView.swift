import SwiftUI

struct FileSizeView: ApplicationView {
    @StateObject private var viewModel = FileSizeViewModel()
    @EnvironmentObject private var applicationsViewModel: ApplicationsViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Update ApplicationView protocol properties
    var score: Int { viewModel.score }
    var isCompleted: Bool { viewModel.score >= 500 } // Complete when score reaches 500
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                explanationSection
                converterSection
                fileSizeReferenceCard
            }
            .padding()
        }
        .navigationTitle("FILE SIZES")
        .navigationBarTitleDisplayMode(.large)
        .background(ThemeManager.backgroundColor.ignoresSafeArea())
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .onAppear {
            viewModel.setApplicationsViewModel(applicationsViewModel)
        }
    }
    
    private var explanationSection: some View {
        VStack(spacing: 16) {
            Text("BINARY FILE SIZES")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text("File sizes in computers use binary prefixes (Ki, Mi, Gi, Ti) based on powers of 2, unlike metric prefixes (K, M, G, T) which use powers of 10.")
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
            
            // Binary multiplier explanation
            VStack(alignment: .leading, spacing: 8) {
                ForEach(FileSizeUnit.allCases, id: \.self) { unit in
                    HStack {
                        Text(unit.rawValue)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(ThemeManager.primaryColor)
                            .frame(width: 50, alignment: .leading)
                        Text(unit.explanation)
                            .font(ThemeManager.bodyFont)
                            .foregroundColor(ThemeManager.secondaryColor)
                    }
                }
            }
            .padding()
            .background(ThemeManager.backgroundColor.opacity(0.7))
            .cornerRadius(8)
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var converterSection: some View {
        HStack(alignment: .top, spacing: 24) {
            // Converter Card
            converterCard
                .frame(maxWidth: .infinity)
            
            // History Card
            if !viewModel.conversionHistory.isEmpty {
                VStack(spacing: 16) {
                    Text("CONVERSION HISTORY")
                        .font(ThemeManager.headlineFont)
                        .foregroundColor(ThemeManager.primaryColor)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.conversionHistory) { conversion in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(conversion.formattedResult)
                                            .font(ThemeManager.bodyFont)
                                            .foregroundColor(ThemeManager.primaryColor)
                                        Text(conversion.binaryExplanation)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundColor(ThemeManager.secondaryColor)
                                    }
                                    Spacer()
                                    Text("+30")
                                        .font(ThemeManager.bodyFont)
                                        .foregroundColor(ThemeManager.primaryColor)
                                }
                                .padding()
                                .background(ThemeManager.backgroundColor.opacity(0.5))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .padding()
                .background(ThemeManager.backgroundColor.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
            }
        }
    }
    
    private var converterCard: some View {
        VStack(spacing: 16) {
            Text("FILE SIZE CONVERTER")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            HStack(spacing: 12) {
                // Source Value Input
                TextField("Value", text: $viewModel.sourceValue)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 120)
                    .multilineTextAlignment(.center)
                
                // Source Unit Picker
                Menu {
                    ForEach(FileSizeUnit.allCases, id: \.self) { unit in
                        Button(unit.rawValue) {
                            viewModel.sourceUnit = unit
                        }
                    }
                } label: {
                    Text(viewModel.sourceUnit.rawValue)
                        .font(ThemeManager.bodyFont)
                        .foregroundColor(ThemeManager.primaryColor)
                        .frame(width: 80)
                        .padding(.vertical, 8)
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .cornerRadius(8)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundColor(ThemeManager.primaryColor)
                
                // Target Unit Picker
                Menu {
                    ForEach(FileSizeUnit.allCases, id: \.self) { unit in
                        Button(unit.rawValue) {
                            viewModel.targetUnit = unit
                        }
                    }
                } label: {
                    Text(viewModel.targetUnit.rawValue)
                        .font(ThemeManager.bodyFont)
                        .foregroundColor(ThemeManager.primaryColor)
                        .frame(width: 80)
                        .padding(.vertical, 8)
                        .background(ThemeManager.backgroundColor.opacity(0.7))
                        .cornerRadius(8)
                }
            }
            
            // Convert Button
            Button(action: viewModel.convert) {
                Text("CONVERT")
                    .font(ThemeManager.headlineFont)
                    .foregroundColor(.black)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(ThemeManager.primaryColor)
                    .cornerRadius(8)
            }
            
            // Result Display (if available)
            if let result = viewModel.conversionResult {
                resultView(result)
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var fileSizeReferenceCard: some View {
        VStack(spacing: 16) {
            Text("COMMON FILE SIZES")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(CommonFileSize.allCases, id: \.self) { fileSize in
                    HStack {
                        Image(systemName: fileSize.icon)
                            .foregroundColor(ThemeManager.primaryColor)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text(fileSize.rawValue)
                                .font(ThemeManager.bodyFont)
                                .foregroundColor(ThemeManager.primaryColor)
                            Text(fileSize.size)
                                .font(ThemeManager.bodyFont)
                                .foregroundColor(ThemeManager.secondaryColor)
                        }
                        
                        Spacer()
                        
                        Text(fileSize.example)
                            .font(ThemeManager.bodyFont)
                            .foregroundColor(ThemeManager.secondaryColor)
                    }
                    .padding(.horizontal)
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
    
    private func resultView(_ result: FileSizeConversionResult) -> some View {
        VStack(spacing: 8) {
            Text(result.formattedResult)
                .font(.system(.title2, design: .monospaced))
                .foregroundColor(ThemeManager.primaryColor)
            
            Text(result.binaryExplanation)
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.5))
        .cornerRadius(8)
    }
}

// New supporting enum for common file sizes
enum CommonFileSize: String, CaseIterable, Identifiable {
    case textFile = "Text Document"
    case image = "Digital Photo"
    case song = "Music Track"
    case movie = "HD Movie"
    case game = "Modern Game"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .textFile: return "doc.text.fill"
        case .image: return "photo.fill"
        case .song: return "music.note"
        case .movie: return "film.fill"
        case .game: return "gamecontroller.fill"
        }
    }
    
    var size: String {
        switch self {
        case .textFile: return "10 KiB - 100 KiB"
        case .image: return "2 MiB - 10 MiB"
        case .song: return "3 MiB - 15 MiB"
        case .movie: return "4 GiB - 15 GiB"
        case .game: return "50 GiB - 150 GiB"
        }
    }
    
    var example: String {
        switch self {
        case .textFile: return "README.md"
        case .image: return "IMG_1234.jpg"
        case .song: return "song.mp3"
        case .movie: return "movie.mp4"
        case .game: return "game.pkg"
        }
    }
}