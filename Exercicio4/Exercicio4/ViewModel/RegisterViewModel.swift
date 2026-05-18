import Foundation
import CoreData
import Combine

class RegisterViewModel: ObservableObject {

    @Published var nome = ""
    @Published var email = ""
    @Published var senha = ""
    @Published var errorMessage = ""
    @Published var sucesso = false

    func cadastrar(context: NSManagedObjectContext) {

        guard !nome.isEmpty, !email.isEmpty, !senha.isEmpty else {
            errorMessage = "Preencha todos os campos"
            return
        }

        let request = NSFetchRequest<NSManagedObject>(entityName: "Usuario")
        request.predicate = NSPredicate(format: "email == %@", email)

        do {
            let resultado = try context.fetch(request)

            if resultado.count > 0 {
                errorMessage = "Email já cadastrado"
                return
            }

            let novo = Usuario(context: context)
            novo.nome = nome
            novo.email = email
            novo.senha = senha

            try context.save()

            sucesso = true
            errorMessage = ""

        } catch {
            errorMessage = "Erro ao cadastrar"
            print(error)
        }
    }
}
