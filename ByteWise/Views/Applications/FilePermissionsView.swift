import SwiftUI

struct FilePermissionsView: ApplicationView {
    @StateObject private var viewModel = FilePermissionsViewModel()
    @EnvironmentObject private var applicationsViewModel: ApplicationsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var score: Int { viewModel.score }
    var isCompleted: Bool { viewModel.score >= 500 }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                explanationSection
                octalNotationSection
                commonPermissionsSection
                permissionMatrixSection
                conversionHistorySection
            }
            .padding()
        }
        .navigationTitle("FILE PERMISSIONS")
        .navigationBarTitleDisplayMode(.large)
        .background(ThemeManager.backgroundColor.ignoresSafeArea())
        .onAppear {
            viewModel.setApplicationsViewModel(applicationsViewModel)
        }
    }
    
    private var explanationSection: some View {
        VStack(spacing: 16) {
            Text("UNIX FILE PERMISSIONS")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text("Unix-like systems use a binary-based permission system to control access to files. Each file has three permission groups (Owner, Group, Others) with three permission types (Read, Write, Execute).")
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
            
            // Permission types explanation
            VStack(alignment: .leading, spacing: 8) {
                ForEach(PermissionType.allCases, id: \.self) { type in
                    HStack {
                        Text(type.symbol)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(ThemeManager.primaryColor)
                            .frame(width: 30)
                        Text(type.explanation)
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
    
    private var octalNotationSection: some View {
        VStack(spacing: 16) {
            Text("OCTAL NOTATION")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            Text("Octal notation represents permissions as three digits, where each digit is the sum of its permission bits: Read (4), Write (2), Execute (1)")
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
            
            // Octal calculation example
            VStack(alignment: .leading, spacing: 8) {
                Text("CALCULATION EXAMPLE")
                    .font(ThemeManager.bodyFont)
                    .foregroundColor(ThemeManager.primaryColor)
                
                Text("rwx = 4 + 2 + 1 = 7\nrw- = 4 + 2 + 0 = 6\nr-x = 4 + 0 + 1 = 5\nr-- = 4 + 0 + 0 = 4")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(ThemeManager.secondaryColor)
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
    
    private var commonPermissionsSection: some View {
        VStack(spacing: 16) {
            Text("COMMON PERMISSIONS")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            ForEach(CommonFilePermission.allCases) { permission in
                HStack {
                    VStack(alignment: .leading) {
                        Text(permission.name)
                            .font(ThemeManager.bodyFont)
                            .foregroundColor(ThemeManager.primaryColor)
                        Text(permission.symbolic)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(ThemeManager.secondaryColor)
                    }
                    
                    Spacer()
                    
                    Text(permission.octal)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                }
                .padding()
                .background(ThemeManager.backgroundColor.opacity(0.5))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var permissionMatrixSection: some View {
        VStack(spacing: 16) {
            Text("PERMISSION MATRIX")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            // Permission matrix
            VStack(spacing: 12) {
                // Header
                HStack {
                    Text("")
                        .frame(width: 80)
                    ForEach(PermissionType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                            .font(ThemeManager.bodyFont)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Permission toggles
                ForEach(UserType.allCases, id: \.self) { user in
                    HStack {
                        Text(user.rawValue)
                            .font(ThemeManager.bodyFont)
                            .frame(width: 80, alignment: .leading)
                        
                        ForEach(PermissionType.allCases, id: \.self) { type in
                            Toggle("", isOn: Binding(
                                get: { viewModel.hasPermission(type, for: user) },
                                set: { _ in viewModel.togglePermission(type, for: user) }
                            ))
                            .toggleStyle(PermissionToggleStyle())
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .padding()
            
            // Notation display
            HStack(spacing: 24) {
                VStack {
                    Text("SYMBOLIC")
                        .font(ThemeManager.bodyFont)
                    Text(viewModel.symbolicNotation)
                        .font(.system(.title, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                }
                
                VStack {
                    Text("OCTAL")
                        .font(ThemeManager.bodyFont)
                    Text(viewModel.octalNotation)
                        .font(.system(.title, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                }
            }

            // Add natural language representation
            Text(viewModel.naturalLanguageDescription)
                .font(ThemeManager.bodyFont)
                .foregroundColor(ThemeManager.secondaryColor)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding()
        .background(ThemeManager.backgroundColor.opacity(0.7))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ThemeManager.secondaryColor, lineWidth: 1)
        )
    }
    
    private var conversionHistorySection: some View {
        VStack(spacing: 16) {
            Text("CONVERSION HISTORY")
                .font(ThemeManager.headlineFont)
                .foregroundColor(ThemeManager.primaryColor)
            
            if viewModel.conversionHistory.isEmpty {
                Text("Try toggling some permissions to see the conversions here!")
                    .font(ThemeManager.bodyFont)
                    .foregroundColor(ThemeManager.secondaryColor)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(Array(viewModel.conversionHistory.prefix(4))) { conversion in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(conversion.symbolic)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(ThemeManager.primaryColor)
                            Text(conversion.octal)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(ThemeManager.secondaryColor)
                        }
                        Spacer()
                        Text("+10")
                            .font(ThemeManager.bodyFont)
                            .foregroundColor(ThemeManager.primaryColor)
                    }
                    .padding()
                    .background(ThemeManager.backgroundColor.opacity(0.5))
                    .cornerRadius(8)
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
}

struct PermissionToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            RoundedRectangle(cornerRadius: 4)
                .fill(configuration.isOn ? ThemeManager.primaryColor : ThemeManager.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(ThemeManager.secondaryColor, lineWidth: 1)
                )
                .frame(width: 30, height: 30)
        }
    }
}

enum CommonFilePermission: String, CaseIterable, Identifiable {
    case readOnly = "Read Only"
    case readWrite = "Read & Write"
    case executable = "Executable"
    case fullAccess = "Full Access"
    case restricted = "Restricted"
    
    var id: String { rawValue }
    
    var symbolic: String {
        switch self {
        case .readOnly: return "r--r--r--"
        case .readWrite: return "rw-rw-r--"
        case .executable: return "rwxr-xr-x"
        case .fullAccess: return "rwxrwxrwx"
        case .restricted: return "rwx------"
        }
    }
    
    var octal: String {
        switch self {
        case .readOnly: return "444"
        case .readWrite: return "664"
        case .executable: return "755"
        case .fullAccess: return "777"
        case .restricted: return "700"
        }
    }
    
    var name: String { rawValue }
} 