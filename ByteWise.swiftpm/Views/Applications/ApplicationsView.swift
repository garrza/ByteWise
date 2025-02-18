import SwiftUI

struct ApplicationsView: View {
    @StateObject private var viewModel: ApplicationsViewModel
    @EnvironmentObject private var progressManager: ProgressManager
    
    init() {
        _viewModel = StateObject(wrappedValue: ApplicationsViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ThemeManager.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        explanationSection
                        applicationGrid
                    }
                    .padding()
                }
            }
            .navigationTitle("APPLICATIONS")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: BinaryApplication.self) { application in
                applicationView(for: application)
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            viewModel.updateProgressManager(progressManager)
        }
    }
    
    private var explanationSection: some View {
        VStack(spacing: 16) {
            Text("REAL WORLD APPLICATIONS")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text("Explore how binary and hexadecimal numbers are used in various computing applications, from color coding to file systems.")
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
    
    private var applicationGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(BinaryApplication.allCases) { application in
                NavigationLink(value: application) {
                    ApplicationCard(
                        application: application,
                        progress: viewModel.applicationProgress[application] ?? ApplicationProgress()
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private func applicationView(for application: BinaryApplication) -> some View {
        switch application {
        case .colorCoding:
            ApplicationWrapper(application: application) {
                ColorCodingView()
            }
        case .fileSize:
            ApplicationWrapper(application: application) {
                FileSizeView()
            }
        case .asciiText:
            ApplicationWrapper(application: application) {
                ASCIITextView()
            }
        case .permissions:
            ApplicationWrapper(application: application) {
                FilePermissionsView()
            }
        }
    }
}

struct ApplicationCard: View {
    let application: BinaryApplication
    let progress: ApplicationProgress
    
    private var achievement: Achievement {
        Achievement.forApplication(application)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: application.systemImage)
                    .font(.title2)
                Text(application.rawValue)
                    .font(ThemeManager.headlineFont)
                Spacer()
                
                if progress.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(application.themeColor)
                }
            }
            .foregroundColor(application.themeColor)
            
            // Description
            Text(application.description)
                .font(ThemeManager.bodyFont)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(application.secondaryColor)
            
            Spacer()
            
            // Achievements
            if !progress.achievements.isEmpty {
                HStack {
                    ForEach(Array(progress.achievements), id: \.self) { achievement in
                        AchievementBadge(type: achievement)
                            .environment(\.themeColor, application.themeColor)
                    }
                    Spacer()
                }
            }
            
            // Progress
            VStack(spacing: 4) {
                ProgressView(value: Double(progress.score) / Double(achievement.requiredScore))
                    .tint(application.themeColor)
                
                Text("\(progress.score) / \(achievement.requiredScore) points")
                    .font(ThemeManager.bodyFont)
                    .foregroundColor(application.secondaryColor)
            }
        }
        .padding()
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(application.secondaryColor, lineWidth: 1)
        )
    }
}

// Add environment key for theme color
private struct ThemeColorKey: EnvironmentKey {
    static let defaultValue: Color = .green
}

extension EnvironmentValues {
    var themeColor: Color {
        get { self[ThemeColorKey.self] }
        set { self[ThemeColorKey.self] = newValue }
    }
}

// Update AchievementBadge to use environment theme color
struct AchievementBadge: View {
    let type: String
    @Environment(\.themeColor) private var themeColor
    
    var icon: String {
        switch type {
        case "color_master": return "paintpalette.fill"
        case "size_expert": return "internaldrive.fill"
        case "ascii_guru": return "character.textbox"
        case "permission_pro": return "lock.shield.fill"
        default: return "star.fill"
        }
    }
    
    var title: String {
        switch type {
        case "color_master": return "Color Master"
        case "size_expert": return "Size Expert"
        case "ascii_guru": return "ASCII Guru"
        case "permission_pro": return "Permission Pro"
        default: return "Achievement"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(title)
                .font(.system(.caption, design: .monospaced))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(themeColor.opacity(0.2))
        .foregroundColor(themeColor)
        .cornerRadius(12)
    }
} 