import SwiftUI

struct ExpenseItemCard: View {
    let date: Date
    let animalType: String
    let itemName: String
    let cost: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(formattedDate(date)).font(DesignSystem.Typography.header(16)).foregroundColor(.white)
                Spacer()
                Text(animalType).font(DesignSystem.Typography.header(16)).foregroundColor(.white)
            }
            .padding(.top, 14).padding(.horizontal, 20).padding(.bottom, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(DesignSystem.Colors.itemInnerBackground)
                    .frame(height: 53)
                
                HStack {
                    Text(itemName).font(DesignSystem.Typography.body(15)).foregroundColor(DesignSystem.Colors.lightGrey)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                    Spacer()
                    HStack(spacing: 4) {
                        Text("\(Int(cost))").font(DesignSystem.Typography.body(16)).foregroundColor(.white)
                        Text("$").font(DesignSystem.Typography.body(16)).foregroundColor(DesignSystem.Colors.mutedWhite)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(DesignSystem.Effects.glassMaterial())
        .cornerRadius(24)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd.MM"; return formatter.string(from: date)
    }
}

struct SaleItemCard: View {
    let date: Date
    let animalType: String
    let productName: String
    let amount: String
    let cost: Double
    let buyer: String
    var otherCategoryName: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(formattedDate(date)).font(DesignSystem.Typography.header(16)).foregroundColor(.white)
                Spacer()
                Text(animalType).font(DesignSystem.Typography.header(16)).foregroundColor(.white)
            }
            .padding(.top, 14).padding(.horizontal, 20).padding(.bottom, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(DesignSystem.Colors.itemInnerBackground)
                    .frame(height: 53)
                
                HStack(spacing: 10) {
                    Text(otherCategoryName ?? productName).font(DesignSystem.Typography.body(15)).foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                    Text(amount).font(DesignSystem.Typography.body(16)).foregroundColor(.white)
                    if !buyer.isEmpty { 
                        Text(buyer).font(DesignSystem.Typography.body(16)).foregroundColor(.white)
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Text("\(Int(cost))").font(DesignSystem.Typography.body(16)).foregroundColor(.white)
                        Text("$").font(DesignSystem.Typography.body(16)).foregroundColor(DesignSystem.Colors.mutedWhite)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(DesignSystem.Effects.glassMaterial())
        .cornerRadius(24)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd.MM"; return formatter.string(from: date)
    }
}

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var showEditIcon: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(DesignSystem.Typography.header(17)).foregroundColor(.white)
            HStack(spacing: 10) {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(DesignSystem.Colors.lightGrey.opacity(0.5)))
                    .foregroundColor(DesignSystem.Colors.lightGrey).font(DesignSystem.Typography.body(15)).keyboardType(keyboardType)
                if showEditIcon { Image("icon_pencil").resizable().frame(width: 24, height: 24).opacity(0.5) }
            }
            .padding(16)
            .background(DesignSystem.Colors.inputFieldBackground)
            .cornerRadius(16)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CustomDropdown<T: RawRepresentable>: View where T.RawValue == String {
    let title: String
    let selectedValue: T
    let options: [T]
    @Binding var isExpanded: Bool
    let onSelect: (T) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(DesignSystem.Typography.header(17)).foregroundColor(.white)
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack(spacing: 10) {
                    Text(selectedValue.rawValue).font(DesignSystem.Typography.body(15)).foregroundColor(DesignSystem.Colors.lightGrey)
                    Spacer()
                    Image(systemName: "triangle.fill").resizable().frame(width: 10, height: 8).rotationEffect(.degrees(isExpanded ? 0 : 180)).foregroundColor(DesignSystem.Colors.orangeBorder)
                }
                .padding(16)
                .background(DesignSystem.Colors.inputFieldBackground)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).inset(by: 0.50).stroke(DesignSystem.Colors.orangeBorder, lineWidth: isExpanded ? 0.50 : 0))
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.rawValue) { option in
                            Text(option.rawValue)
                                .font(DesignSystem.Typography.body(15))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 57)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onSelect(option)
                                    withAnimation { isExpanded = false }
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 230)
                .background(Color(red: 0.27, green: 0.27, blue: 0.48))
                .cornerRadius(24)
                .overlay(RoundedRectangle(cornerRadius: 24).inset(by: 0.50).stroke(DesignSystem.Colors.orangeBorder, lineWidth: 0.50))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct FarmEmptyState: View {
    let title: String; let message: String; let icon: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon).font(.system(size: 48)).foregroundColor(DesignSystem.Colors.grey.opacity(0.5))
            VStack(spacing: 8) {
                Text(title).font(DesignSystem.Typography.header(20)).foregroundColor(DesignSystem.Colors.white)
                Text(message).font(DesignSystem.Typography.body(16)).foregroundColor(DesignSystem.Colors.grey).multilineTextAlignment(.center)
            }
        }
        .padding().frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct StatSummaryCard: View {
    let title: String; let income: Double; let expense: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(DesignSystem.Typography.header(16)).foregroundColor(.white)
                .padding(.top, 14).padding(.leading, 20).padding(.bottom, 10)
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(DesignSystem.Colors.itemInnerBackground)
                
                HStack(spacing: 0) {
                    HStack(spacing: 6) {
                        Text("Income:").font(DesignSystem.Typography.body(15)).foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.78))
                        Text("\(Int(income))").font(DesignSystem.Typography.header(20)).foregroundColor(DesignSystem.Colors.incomeYellow)
                        Text("$").font(DesignSystem.Typography.body(16)).foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.49))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 6) {
                        Text("Expenses:").font(DesignSystem.Typography.body(15)).foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.78))
                        Text("\(Int(expense))").font(DesignSystem.Typography.header(20)).foregroundColor(DesignSystem.Colors.expenseRed)
                        Text("$").font(DesignSystem.Typography.body(16)).foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.49))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
            }
            .frame(height: 53)
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(DesignSystem.Effects.glassMaterial())
        .cornerRadius(24)
    }
}

struct DonutChartView: View {
    let title: String; let subtitle: String; let items: [(String, Double, Color)]
    let onDetailsPressed: () -> Void
    var total: Double { let sum = items.reduce(0) { $0 + $1.1 }; return sum == 0 ? 1 : sum }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 10) {
                    Image("coin").resizable().frame(width: 28, height: 28)
                    Text(title).font(DesignSystem.Typography.body(14)).foregroundColor(.white)
                }
                Spacer()
                Button(action: onDetailsPressed) {
                    Text("Details")
                        .font(DesignSystem.Typography.medium(14))
                        .foregroundColor(DesignSystem.Colors.buttonText)
                        .frame(width: 108, height: 31)
                        .background(DesignSystem.Colors.buttonBackground)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(DesignSystem.Colors.buttonBorder, lineWidth: 0.5)
                        )
                }
            }
            Text(subtitle).font(DesignSystem.Typography.body(13)).foregroundColor(.white.opacity(0.6)).padding(.bottom, 10)
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.06, green: 0, blue: 0.17).opacity(0.86))
                        .frame(width: 150, height: 150)
                        .blur(radius: 40)
                    
                    Circle().stroke(Color.white.opacity(0.05), lineWidth: 30).frame(width: 140, height: 140)
                    if items.reduce(0, { $0 + $1.1 }) > 0 {
                        ForEach(0..<items.count, id: \.self) { index in
                            let item = items[index]
                            let trimValue = item.1 / total
                            let previousSum = items.prefix(index).reduce(0) { $0 + $1.1 }
                            let startTrim = previousSum / total
                            Circle().trim(from: startTrim, to: startTrim + trimValue)
                                .stroke(item.2, style: StrokeStyle(lineWidth: 30, lineCap: .butt))
                                .frame(width: 140, height: 140)
                                .rotationEffect(.degrees(-90))
                        }
                    }
                }
                .frame(height: 160)
                Spacer()
            }
            HStack {
                Spacer()
                HStack(spacing: 20) {
                    ForEach(items, id: \.0) { item in
                        HStack(spacing: 6) {
                            Circle().fill(item.2).frame(width: 8, height: 8)
                            VStack(alignment: .leading, spacing: 0) {
                                Text(item.0).font(DesignSystem.Typography.medium(12)).foregroundColor(.white.opacity(0.7))
                                Text("\(Int(item.1))$").font(DesignSystem.Typography.header(12)).foregroundColor(.white)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding(20).background(DesignSystem.Effects.glassMaterial()).cornerRadius(24)
    }
}
