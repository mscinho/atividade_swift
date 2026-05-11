import SwiftUI

struct InvestmentsListView: View {

    let category: InvestmentCategory
    @Binding var path: [AppRoute]
    @StateObject private var viewModel = InvestmentsViewModel()

    var body: some View {
        List(viewModel.getProducts(for: category)) { product in
            Button(product.name) {
                path.append(.details(product))
            }
        }
        .navigationTitle(category.name)
    }
}
