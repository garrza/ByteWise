import SwiftUI

protocol ApplicationView: View {
    var score: Int { get }
    var isCompleted: Bool { get }
}

struct ApplicationWrapper<Content: ApplicationView>: View {
    let application: BinaryApplication
    let content: () -> Content
    @EnvironmentObject private var viewModel: ApplicationsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(application: BinaryApplication, @ViewBuilder content: @escaping () -> Content) {
        self.application = application
        self.content = content
    }
    
    var body: some View {
        content()
            .environmentObject(viewModel)
            .onAppear {
                if let asciiView = content() as? ASCIITextView {
                    asciiView.viewModel.setApplicationsViewModel(viewModel)
                }
            }
            .onDisappear {
                if content().isCompleted {
                    viewModel.updateProgress(
                        for: application,
                        score: content().score
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("APPLICATIONS")
                        }
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(ThemeManager.primaryColor)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
} 