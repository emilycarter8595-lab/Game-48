import SwiftUI

struct AddSaleView: View {
    @EnvironmentObject var storageService: StorageService
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool
    
    var editingSale: Sale?
    
    @State private var selectedCategory: ProductCategory = .eggs
    @State private var selectedAnimal: AnimalType = .chicken
    @State private var cost = ""
    @State private var amount = ""
    @State private var buyer = ""
    @State private var otherCategoryName = ""
    @State private var isCategoryDropdownExpanded = false
    @State private var isAnimalDropdownExpanded = false
    
    init(editingSale: Sale? = nil) {
        self.editingSale = editingSale
        _selectedCategory = State(initialValue: editingSale?.category ?? .eggs)
        _selectedAnimal = State(initialValue: editingSale?.animalType ?? .chicken)
        _cost = State(initialValue: editingSale != nil ? "\(Int(editingSale!.cost))" : "")
        _amount = State(initialValue: editingSale != nil ? "\(Int(editingSale!.amount))" : "")
        _buyer = State(initialValue: editingSale?.buyer ?? "")
        _otherCategoryName = State(initialValue: editingSale?.otherCategoryName ?? "")
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
                    Text("New sale").font(DesignSystem.Typography.header(28)).foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.left").opacity(0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 80)
                .padding(.bottom, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        CustomDropdown(title: "Category", selectedValue: selectedCategory, options: ProductCategory.allCases, isExpanded: $isCategoryDropdownExpanded, onSelect: { selectedCategory = $0 }).zIndex(2)
                        
                        if selectedCategory == .other {
                            InputField(title: "Custom Category Name", placeholder: "Enter category name", text: $otherCategoryName).focused($isFocused)
                        }
                        
                        CustomDropdown(title: "Animal", selectedValue: selectedAnimal, options: AnimalType.allCases, isExpanded: $isAnimalDropdownExpanded, onSelect: { selectedAnimal = $0 }).zIndex(1)
                        InputField(title: "Total Sum ($)", placeholder: "0.0", text: $cost, keyboardType: .decimalPad).focused($isFocused)
                        InputField(title: "Quantity (kg)", placeholder: "0.0", text: $amount, keyboardType: .decimalPad).focused($isFocused)
                        InputField(title: "Buyer", placeholder: "Enter name", text: $buyer).focused($isFocused)
                        
                        if !isCategoryDropdownExpanded && !isAnimalDropdownExpanded {
                            Button(action: save) {
                                Text("Save").font(DesignSystem.Typography.medium(16)).foregroundColor(.black).frame(width: 133, height: 42).background(Color.white).cornerRadius(36)
                            }
                            .padding(.top, 40)
                            .disabled(cost.isEmpty || amount.isEmpty || (selectedCategory == .other && otherCategoryName.isEmpty))
                            .opacity(cost.isEmpty || amount.isEmpty || (selectedCategory == .other && otherCategoryName.isEmpty) ? 0.5 : 1)
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
        let costVal = Double(cost.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)) ?? 0
        let amountVal = Double(amount.replacingOccurrences(of: " pcs", with: "").replacingOccurrences(of: " kg", with: "").trimmingCharacters(in: .whitespaces)) ?? 0
        
        if let editing = editingSale {
            let updated = Sale(id: editing.id, date: editing.date, category: selectedCategory, animalType: selectedAnimal, amount: amountVal, cost: costVal, buyer: buyer.isEmpty ? nil : buyer, otherCategoryName: selectedCategory == .other ? otherCategoryName : nil)
            storageService.updateSale(updated)
        } else {
            let sale = Sale(date: Date(), category: selectedCategory, animalType: selectedAnimal, amount: amountVal, cost: costVal, buyer: buyer.isEmpty ? nil : buyer, otherCategoryName: selectedCategory == .other ? otherCategoryName : nil)
            storageService.addSale(sale)
        }
        dismiss()
    }
}
