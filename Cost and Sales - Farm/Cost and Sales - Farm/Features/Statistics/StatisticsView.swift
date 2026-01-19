import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var storageService: StorageService
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Statistic")
                .font(DesignSystem.Typography.header(28))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    StatSummaryCard(
                        title: "Day",
                        income: storageService.totalSales(for: .day),
                        expense: storageService.totalExpenses(for: .day)
                    )
                    
                    StatSummaryCard(
                        title: "Month",
                        income: storageService.totalSales(for: .month),
                        expense: storageService.totalExpenses(for: .month)
                    )
                    
                    let topExpenses = storageService.topExpensesByAnimal()
                    DonutChartView(
                        title: "Spending",
                        subtitle: "Who is the most precious?",
                        items: topExpenses.enumerated().map { index, item in
                            (item.0.rawValue.lowercased(), item.1, chartColor(for: index, isSpending: true))
                        },
                        onDetailsPressed: { router.selectedTab = 1 }
                    )
                    
                    let topSales = storageService.topSalesByProduct()
                    DonutChartView(
                        title: "Sales",
                        subtitle: "Who brings the most?",
                        items: topSales.enumerated().map { index, item in
                            (item.0.rawValue.lowercased(), item.1, chartColor(for: index, isSpending: false))
                        },
                        onDetailsPressed: { router.selectedTab = 2 }
                    )
                    
                    Spacer(minLength: 150)
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(DesignSystem.Gradients.mainBackground())
        .navigationBarHidden(true)
    }
    
    private func chartColor(for index: Int, isSpending: Bool) -> Color {
        let colors = isSpending ? 
            [DesignSystem.Colors.chartBlue, DesignSystem.Colors.chartLightBlue, DesignSystem.Colors.chartPink] :
            [DesignSystem.Colors.incomeYellow, DesignSystem.Colors.chartPurple, DesignSystem.Colors.chartCyan]
        return colors[index % colors.count]
    }
}
