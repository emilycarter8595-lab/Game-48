import Foundation
import SwiftUI
import Combine

@MainActor
class StorageService: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet { saveExpenses() }
    }
    @Published var sales: [Sale] = [] {
        didSet { saveSales() }
    }
    
    private let expensesKey = "farm_expenses"
    private let salesKey = "farm_sales"
    
    init() {
        loadExpenses()
        loadSales()
    }
    
    func totalExpenses(for period: Calendar.Component) -> Double {
        let now = Date()
        return expenses.filter {
            Calendar.current.isDate($0.date, equalTo: now, toGranularity: period)
        }.reduce(0) { $0 + $1.cost }
    }
    
    func totalSales(for period: Calendar.Component) -> Double {
        let now = Date()
        return sales.filter {
            Calendar.current.isDate($0.date, equalTo: now, toGranularity: period)
        }.reduce(0) { $0 + $1.cost }
    }
    
    func topExpensesByAnimal() -> [(AnimalType, Double)] {
        var dict: [AnimalType: Double] = [:]
        for expense in expenses {
            dict[expense.animalType, default: 0] += expense.cost
        }
        return dict.sorted { $0.value > $1.value }.prefix(3).map { ($0.key, $0.value) }
    }
    
    func topSalesByProduct() -> [(ProductCategory, Double)] {
        var dict: [ProductCategory: Double] = [:]
        for sale in sales {
            dict[sale.category, default: 0] += sale.cost
        }
        return dict.sorted { $0.value > $1.value }.prefix(3).map { ($0.key, $0.value) }
    }
    
    private func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: expensesKey)
        }
    }
    
    private func saveSales() {
        if let encoded = try? JSONEncoder().encode(sales) {
            UserDefaults.standard.set(encoded, forKey: salesKey)
        }
    }
    
    private func loadExpenses() {
        if let data = UserDefaults.standard.data(forKey: expensesKey),
           let decoded = try? JSONDecoder().decode([Expense].self, from: data) {
            expenses = decoded
        }
    }
    
    private func loadSales() {
        if let data = UserDefaults.standard.data(forKey: salesKey),
           let decoded = try? JSONDecoder().decode([Sale].self, from: data) {
            sales = decoded
        }
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
    
    func addSale(_ sale: Sale) {
        sales.append(sale)
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
    }
    
    func deleteSale(_ sale: Sale) {
        sales.removeAll { $0.id == sale.id }
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }
    
    func updateSale(_ sale: Sale) {
        if let index = sales.firstIndex(where: { $0.id == sale.id }) {
            sales[index] = sale
        }
    }
}
