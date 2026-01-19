import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var storageService: StorageService
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    var editingExpense: Expense?
    
    @State private var name = ""
    @State private var amount = ""
    @State private var cost = ""
    @State private var selectedAnimal: AnimalType = .cow
    @State private var isAnimalDropdownExpanded = false
    
    init(editingExpense: Expense? = nil) {
        self.editingExpense = editingExpense
        _name = State(initialValue: editingExpense?.name ?? "")
        _amount = State(initialValue: editingExpense != nil ? "\(Int(editingExpense!.amount))" : "")
        _cost = State(initialValue: editingExpense != nil ? "\(Int(editingExpense!.cost))" : "")
        _selectedAnimal = State(initialValue: editingExpense?.animalType ?? .cow)
    }
    
    var body: some View {
        ZStack {
            DesignSystem.Gradients.mainBackground()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left").font(.system(size: 24, weight: .bold)).foregroundColor(.white)
                    }
                    Spacer()
                    Text("New spending").font(DesignSystem.Typography.header(28)).foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.left").opacity(0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 80)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        InputField(title: "Name", placeholder: "Enter name", text: $name).focused($isFocused)
                        InputField(title: "Quantity (kg)", placeholder: "0.0", text: $amount, keyboardType: .decimalPad).focused($isFocused)
                        InputField(title: "Total Cost ($)", placeholder: "0.0", text: $cost, keyboardType: .decimalPad).focused($isFocused)
                        CustomDropdown(title: "Animal Type", selectedValue: selectedAnimal, options: AnimalType.allCases, isExpanded: $isAnimalDropdownExpanded, onSelect: { selectedAnimal = $0 })
                        
                        if !isAnimalDropdownExpanded {
                            Button(action: save) {
                                Text("Save").font(DesignSystem.Typography.medium(16)).foregroundColor(.black).frame(width: 133, height: 42).background(Color.white).cornerRadius(36)
                            }
                            .padding(.top, 40)
                            .disabled(name.isEmpty || amount.isEmpty || cost.isEmpty)
                            .opacity(name.isEmpty || amount.isEmpty || cost.isEmpty ? 0.5 : 1)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 150)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarHidden(true)
        .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Done") { isFocused = false } } }
    }
    
    private func save() {
        let amountStr = amount.replacingOccurrences(of: " kg", with: "").trimmingCharacters(in: .whitespaces)
        let costStr = cost.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)
        let amountVal = Double(amountStr) ?? 0; let costVal = Double(costStr) ?? 0
        
        if let editing = editingExpense {
            let updated = Expense(id: editing.id, date: editing.date, name: name, amount: amountVal, cost: costVal, animalType: selectedAnimal)
            storageService.updateExpense(updated)
        } else {
            let expense = Expense(date: Date(), name: name, amount: amountVal, cost: costVal, animalType: selectedAnimal)
            storageService.addExpense(expense)
        }
        dismiss()
    }
}
