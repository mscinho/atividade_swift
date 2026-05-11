import Foundation

struct CartItem: Identifiable {
    let id: UUID
    let product: InvestmentProduct
    var quantity: Int

    var subtotal: Double {
        minimumValue * Double(quantity)
    }

    private var minimumValue: Double {
        product.minimumValue
    }
}
