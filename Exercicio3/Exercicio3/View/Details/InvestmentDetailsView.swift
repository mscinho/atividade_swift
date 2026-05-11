import SwiftUI

struct InvestmentDetailsView: View {

    let product: InvestmentProduct
    @StateObject private var cartViewModel = CartViewModel()

    var body: some View {
        VStack(spacing: 16) {

            Text(product.name)
                .font(.title)
                .bold()

            Text(product.description)

            Text("Rentabilidade: \(product.annualReturn, specifier: "%.1f")% a.a.")
            Text("Valor mínimo: R$ \(product.minimumValue, specifier: "%.2f")")

            Button("Adicionar ao carrinho") {
                cartViewModel.addProduct(product)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Detalhes")
    }
}
