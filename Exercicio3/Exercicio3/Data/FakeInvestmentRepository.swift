import Foundation


final class FakeInvestmentRepository {
    
    let fixedIncome = InvestmentCategory(
        id: UUID(),
        name: "Renda Fixa"
    )
    
    let multiMarket = InvestmentCategory(
        id: UUID(),
        name: "Multimercado"
    )
    
    let variableIncome = InvestmentCategory(
        id: UUID(),
        name: "Renda Variável"
    )
    
    func getCategories() -> [InvestmentCategory] {
        return [fixedIncome, multiMarket, variableIncome]
    }
    
    func getProducts() -> [InvestmentProduct] {
        return [
            // Renda Fixa
            InvestmentProduct(
                id: UUID(),
                name: "XPTO Tesouro Digital",
                category: fixedIncome,
                description: "Fundo de renda fixa com foco em títulos públicos.",
                annualReturn: 8.5,
                minimumValue: 1000
            ),
            
            InvestmentProduct(
                id: UUID(),
                name: "XPTO CDB Premium",
                category: fixedIncome,
                description: "CDB fictício do Banco XPTO com liquidez diária.",
                annualReturn: 9.2,
                minimumValue: 2000
            ),
            
            // Multimercado
            InvestmentProduct(
                id: UUID(),
                name: "XPTO Estratégia Global",
                category: multiMarket,
                description: "Fundo multimercado com alocação global.",
                annualReturn: 12.0,
                minimumValue: 3000
            ),
            
            // Renda Variável
            InvestmentProduct(
                id: UUID(),
                name: "XPTO Ações Brasil",
                category: variableIncome,
                description: "Fundo de ações focado no mercado brasileiro.",
                annualReturn: 15.0,
                minimumValue: 5000
            )
        ]
    }
}
