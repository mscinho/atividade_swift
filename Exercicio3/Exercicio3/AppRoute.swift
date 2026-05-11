import Foundation

enum AppRoute: Hashable {
    case list(InvestmentCategory)
    case details(InvestmentProduct)
    case cart
}
