import SwiftUI

struct CartView: View {

    @StateObject private var viewModel = CartViewModel()

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                HStack {
                    Text(item.product.name)
                    Spacer()
                    Text("Qtd: \(item.quantity)")
                }
            }

            Text("Total: R$ \(viewModel.totalAmount, specifier: "%.2f")")
                .font(.headline)
        }
        .navigationTitle("Carrinho")
    }
}
