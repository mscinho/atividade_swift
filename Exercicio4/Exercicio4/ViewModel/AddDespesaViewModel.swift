import Foundation
import CoreData
import Combine

class AddDespesaViewModel: ObservableObject {

    @Published var valor: String = ""
    @Published var categoria: Categoria = .energia
    @Published var errorMessage: String = ""

    func salvar(context: NSManagedObjectContext,
                mes: String,
                onSuccess: () -> Void) {

        guard let valorDouble = Double(valor), valorDouble > 0 else {
            errorMessage = "Digite um valor válido"
            return
        }

        let nova = Despesa(context: context)
        nova.id = UUID()
        nova.categoria = categoria.rawValue
        nova.valor = valorDouble
        nova.mes = mes
        nova.data = Date()

        do {
            try context.save()
            errorMessage = ""
            onSuccess()
        } catch {
            errorMessage = "Erro ao salvar"
            print(error)
        }
    }
}

