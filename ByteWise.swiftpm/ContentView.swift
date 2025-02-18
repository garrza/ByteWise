import SwiftUI

struct ContentView: View {
    @StateObject private var progressManager = ProgressManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BinaryBasicsView()
                .tabItem {
                    VStack {
                        Image(systemName: "01.square")
                            .environment(\.symbolVariants, .fill)
                        Text("BINARY")
                    }
                }
                .tag(0)
            
            BinaryOperationsView()
                .tabItem {
                    VStack {
                        Image(systemName: "plus.forwardslash.minus")
                            .environment(\.symbolVariants, .fill)
                        Text("OPS")
                    }
                }
                .tag(1)
            
            HexadecimalView()
                .tabItem {
                    VStack {
                        Image(systemName: "number")
                            .environment(\.symbolVariants, .fill)
                        Text("HEX")
                    }
                }
                .tag(2)
            
            ApplicationsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                            .environment(\.symbolVariants, .fill)
                        Text("APPS")
                    }
                }
                .tag(3)
        }
        .environmentObject(progressManager)
        .preferredColorScheme(.dark)
        .accentColor(ThemeManager.primaryColor)
        .onAppear {
            configureTabBarAppearance()
            configureNavigationBarAppearance()
        }
        .overlay(
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(ThemeManager.primaryColor)
                    .opacity(0.6)
                    .blur(radius: 0.5)
                
                Spacer()
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(ThemeManager.primaryColor)
                    .opacity(0.3)
                    .blur(radius: 1)
                    .padding(.bottom, UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .first?
                        .keyWindow?
                        .safeAreaInsets.bottom ?? 0)
            }
        )
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear
        
        let borderSize: CGFloat = 1.0
        appearance.shadowImage = UIImage.gradientImage(
            bounds: CGRect(x: 0, y: 0, width: 1, height: borderSize),
            colors: [
                ThemeManager.primaryUIColor.withAlphaComponent(0.6),
                ThemeManager.primaryUIColor.withAlphaComponent(0.0)
            ]
        )
        
        // Create base appearance for tab items
        let normalAppearance = UITabBarItemAppearance()
    
        normalAppearance.normal.iconColor = ThemeManager.secondaryUIColor
        normalAppearance.normal.titleTextAttributes = [
            .foregroundColor: ThemeManager.secondaryUIColor,
            .font: UIFont.monospacedSystemFont(ofSize: 11, weight: .medium),
            .kern: 0.3
        ]
        
        normalAppearance.selected.iconColor = ThemeManager.primaryUIColor
        normalAppearance.selected.titleTextAttributes = [
            .foregroundColor: ThemeManager.primaryUIColor,
            .font: UIFont.monospacedSystemFont(ofSize: 11, weight: .bold),
            .kern: 0.3
        ]
        
        normalAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        normalAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        appearance.stackedLayoutAppearance = normalAppearance
        appearance.inlineLayoutAppearance = normalAppearance
        appearance.compactInlineLayoutAppearance = normalAppearance
        
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.unselectedItemTintColor = ThemeManager.secondaryUIColor.withAlphaComponent(0.7)
        tabBar.tintColor = ThemeManager.primaryUIColor
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 4
        
        DispatchQueue.main.async {
            tabBar.selectedItem = tabBar.items?.first
        }
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        appearance.titleTextAttributes = [
            .foregroundColor: ThemeManager.primaryUIColor,
            .font: UIFont.monospacedSystemFont(ofSize: 17, weight: .bold)
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: ThemeManager.primaryUIColor,
            .font: UIFont.monospacedSystemFont(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = ThemeManager.primaryUIColor
    }
}

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}
