import SwiftUI
import Combine

enum AppScreen: Hashable {
    case statistics
    case expenses
    case sales
    case addExpense
    case addSale
    case editExpense(Expense)
    case editSale(Sale)
}

class Router: ObservableObject {
    @Published var expensesPath = [AppScreen]()
    @Published var salesPath = [AppScreen]()
    @Published var selectedTab: Int = 1
    
    func navigate(to screen: AppScreen) {
        if selectedTab == 1 {
            expensesPath.append(screen)
        } else if selectedTab == 2 {
            salesPath.append(screen)
        }
    }
    
    func pop() {
        if selectedTab == 1 && !expensesPath.isEmpty {
            expensesPath.removeLast()
        } else if selectedTab == 2 && !salesPath.isEmpty {
            salesPath.removeLast()
        }
    }
}
