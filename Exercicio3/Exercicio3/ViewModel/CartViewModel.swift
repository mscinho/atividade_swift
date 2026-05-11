import Foundation
import Combine

final class CartViewModel: ObservableObject {

    @Published var items: [CartItem] = []

    var totalAmount: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    func addProduct(_ product: InvestmentProduct) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            let newItem = CartItem(
                id: UUID(),
                product: product,
                quantity: 1
            )
            items.append(newItem)
        }
    }

    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    func clearCart() {
        items.removeAll()
    }
}
