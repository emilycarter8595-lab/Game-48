import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var storageService = StorageService()
    @StateObject private var router = Router()
    @State private var showSplash = false
    
    init() {
        DesignSystem.registerFonts()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundColor = UIColor(DesignSystem.Colors.tabBackground.opacity(0.4))
        appearance.shadowColor = .clear
        
        let itemAppearance = UITabBarItemAppearance()
        let font = UIFont(name: "Poppins-SemiBold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .semibold)
        
        itemAppearance.normal.titleTextAttributes = [
            .font: font,
            .foregroundColor: UIColor(DesignSystem.Colors.tabInactive)
        ]
        itemAppearance.selected.titleTextAttributes = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        
        appearance.stackedLayoutAppearance = itemAppearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $router.selectedTab) {
                StatisticsView()
                    .tabItem {
                        Label("Statistics", image: router.selectedTab == 0 ? "tab_statistics_on" : "tab_statistics_off")
                    }
                    .tag(0)
                
                NavigationStack(path: $router.expensesPath) {
                    ExpensesView()
                        .navigationDestination(for: AppScreen.self) { screen in
                            destinationView(for: screen)
                        }
                }
                .tabItem {
                    Label("Expenses", image: router.selectedTab == 1 ? "tab_expenses_on" : "tab_expenses_off")
                }
                .tag(1)
                
                NavigationStack(path: $router.salesPath) {
                    SalesView()
                        .navigationDestination(for: AppScreen.self) { screen in
                            destinationView(for: screen)
                        }
                }
                .tabItem {
                    Label("Sales", image: router.selectedTab == 2 ? "tab_sales_on" : "tab_sales_off")
                }
                .tag(2)
            }
            .tint(DesignSystem.Colors.accentYellow)
            .environmentObject(router)
            .environmentObject(storageService)
            
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for screen: AppScreen) -> some View {
        switch screen {
        case .statistics:
            StatisticsView()
        case .expenses:
            ExpensesView()
        case .sales:
            SalesView()
        case .addExpense:
            AddExpenseView()
        case .addSale:
            AddSaleView()
        case .editExpense(let expense):
            AddExpenseView(editingExpense: expense)
        case .editSale(let sale):
            AddSaleView(editingSale: sale)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StorageService())
}
