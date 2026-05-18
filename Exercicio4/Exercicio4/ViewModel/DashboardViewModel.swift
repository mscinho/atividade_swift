import CoreData
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {

    @Published var despesas: [Despesa] = []
    @Published var nomeUsuario: String = ""

    func carregar(context: NSManagedObjectContext, mes: String) {
        let request: NSFetchRequest<Despesa> = Despesa.fetchRequest()
        request.predicate = NSPredicate(format: "mes == %@", mes)

        do {
            despesas = try context.fetch(request)
        } catch {
            print("Erro ao carregar despesas")
        }
    }

    func adicionar(context: NSManagedObjectContext,
                   categoria: String,
                   valor: Double,
                   mes: String) {

        let nova = Despesa(context: context)
        nova.id = UUID()
        nova.categoria = categoria
        nova.valor = valor
        nova.mes = mes
        nova.data = Date()

        do {
            try context.save()
            carregar(context: context, mes: mes)
        } catch {
            print("Erro ao salvar")
        }
    }

    func deletar(at offsets: IndexSet,
                 context: NSManagedObjectContext,
                 mes: String) {

        offsets.map { despesas[$0] }.forEach(context.delete)

        do {
            try context.save()
            carregar(context: context, mes: mes)
        } catch {
            print("Erro ao deletar")
        }
    }

    func total() -> Double {
        despesas.reduce(0) { $0 + $1.valor }
    }

    func chartData() -> [(categoria: String, valor: Double)] {
        let dict = Dictionary(grouping: despesas, by: { $0.categoria ?? "" })
            .mapValues { $0.reduce(0) { $0 + $1.valor } }

        return dict.map { (categoria: $0.key, valor: $0.value) }
    }

    func ranking() -> [(categoria: String, valor: Double)] {
        chartData().sorted { $0.valor > $1.valor }
    }

    func buscarUsuario(context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Usuario")

        do {
            let usuarios = try context.fetch(request)

            if let user = usuarios.first,
               let nome = user.value(forKey: "nome") as? String {
                nomeUsuario = nome
            }

        } catch {
            print("Erro ao buscar usuário")
        }
    }

    func logout(context: NSManagedObjectContext) {
        UIApplication.shared.windows.first?.rootViewController =
        UIHostingController(rootView: LoginView()
            .environment(\.managedObjectContext, context))
    }
}
