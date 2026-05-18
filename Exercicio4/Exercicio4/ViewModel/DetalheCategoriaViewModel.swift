import CoreData
import Combine

class DetalheCategoriaViewModel: ObservableObject {

    @Published var despesas: [Despesa] = []

    func carregar(context: NSManagedObjectContext,
                  categoria: String,
                  mes: String) {

        let request: NSFetchRequest<Despesa> = Despesa.fetchRequest()
        request.predicate = NSPredicate(
            format: "categoria == %@ AND mes == %@",
            categoria,
            mes
        )

        do {
            despesas = try context.fetch(request)
        } catch {
            print("Erro ao carregar")
        }
    }

    func deletar(at offsets: IndexSet,
                 context: NSManagedObjectContext,
                 categoria: String,
                 mes: String) {

        offsets.map { despesas[$0] }.forEach(context.delete)

        do {
            try context.save()
            carregar(context: context, categoria: categoria, mes: mes)
        } catch {
            print("Erro ao deletar")
        }
    }

    func editar(despesa: Despesa,
                novoValor: Double,
                context: NSManagedObjectContext,
                categoria: String,
                mes: String) {

        despesa.valor = novoValor

        do {
            try context.save()
            carregar(context: context, categoria: categoria, mes: mes)
        } catch {
            print("Erro ao editar")
        }
    }
}
