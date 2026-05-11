import Foundation
import Combine

final class InvestmentsViewModel: ObservableObject {

    private let repository = FakeInvestmentRepository()

    @Published var categories: [InvestmentCategory] = []
    @Published var products: [InvestmentProduct] = []

    init() {
        loadData()
    }

    private func loadData() {
        categories = repository.getCategories()
        products = repository.getProducts()
    }

    func getProducts(for category: InvestmentCategory) -> [InvestmentProduct] {
        products.filter { $0.category.id == category.id }
    }
}
