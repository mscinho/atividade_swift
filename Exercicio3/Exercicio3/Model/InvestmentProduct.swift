import Foundation

struct InvestmentProduct: Identifiable, Hashable {
    let id: UUID
    let name: String
    let category: InvestmentCategory
    let description: String
    let annualReturn: Double
    let minimumValue: Double
}
