import SwiftUI

struct SalesView: View {
    @EnvironmentObject var storageService: StorageService
    @EnvironmentObject var router: Router
    @State private var revealedSaleId: UUID? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Sales")
                .font(DesignSystem.Typography.header(28))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            HStack {
                Text("New sale")
                    .font(DesignSystem.Typography.header(20))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { router.navigate(to: .addSale) }) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 44, height: 44)
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if storageService.sales.isEmpty {
                        FarmEmptyState(title: "No sales records", message: "You haven't added any sales yet", icon: "cart")
                            .padding(.top, 100)
                    } else {
                        ForEach(storageService.sales.reversed()) { sale in
                            SaleRow(
                                sale: sale,
                                revealedSaleId: $revealedSaleId,
                                onDelete: { deleteSale(sale) },
                                onEdit: { router.navigate(to: .editSale(sale)) }
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 150)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(DesignSystem.Gradients.mainBackground())
        .navigationBarHidden(true)
    }
    
    private func deleteSale(_ sale: Sale) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000)
            storageService.deleteSale(sale)
        }
    }
}

struct SaleRow: View {
    let sale: Sale
    @Binding var revealedSaleId: UUID?
    let onDelete: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            SaleItemCard(
                date: sale.date,
                animalType: sale.animalType.rawValue,
                productName: sale.category.rawValue,
                amount: "\(Int(sale.amount))",
                cost: sale.cost,
                buyer: sale.buyer ?? "",
                otherCategoryName: sale.otherCategoryName
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    if revealedSaleId == sale.id { revealedSaleId = nil } else { revealedSaleId = sale.id }
                }
            }
            
            if revealedSaleId == sale.id {
                HStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Button(action: onDelete) {
                            ZStack {
                                Circle().fill(DesignSystem.Colors.expenseRed).frame(width: 50, height: 50)
                                Image("icon_trash").resizable().frame(width: 24, height: 24)
                            }
                        }
                        Text("Delete").font(DesignSystem.Typography.body(11)).foregroundColor(.white)
                    }
                    
                    VStack(spacing: 4) {
                        Button(action: onEdit) {
                            ZStack {
                                Circle().fill(DesignSystem.Colors.incomeYellow).frame(width: 50, height: 50)
                                Image("icon_edit").resizable().frame(width: 24, height: 24)
                            }
                        }
                        Text("Edit").font(DesignSystem.Typography.body(11)).foregroundColor(.white)
                    }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
    }
}
