import SwiftUI

struct HomeView: View {

    @State private var path: [AppRoute] = []
    @StateObject private var viewModel = InvestmentsViewModel()

    var body: some View {
        NavigationStack(path: $path) {

            List(viewModel.categories) { category in
                Button(category.name) {
                    path.append(.list(category))
                }
            }
            .navigationTitle("Banco XPTO")

            .navigationDestination(for: AppRoute.self) { route in
                switch route {

                case .list(let category):
                    InvestmentsListView(
                        category: category,
                        path: $path
                    )

                case .details(let product):
                    InvestmentDetailsView(product: product)

                case .cart:
                    CartView()
                }
            }
        }
    }
}
