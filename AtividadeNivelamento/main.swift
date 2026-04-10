// Atividade de acompanhamento - Nivelamento
import Foundation

// MODELOS
struct Contato {
    var id: Int
    var nome: String
    var idade: UInt
    var telefone: String
    var email: String
    
    init(_ id: Int, _ nome: String, _ idade: UInt, _ telefone: String, _ email: String) {
        self.id = id
        self.nome = nome
        self.idade = idade
        self.telefone = telefone
        self.email = email
    }
}

struct ContatoEntrada {
    var nome: String
    var idadeSrt: String
    var telefone: String
    var email: String
    
    init(_ nome: String, _ idadeSrt: String, _ telefone: String, _ email: String) {
        self.nome = nome
        self.idadeSrt = idadeSrt
        self.telefone = telefone
        self.email = email
    }
}

// PROTOCOLOS
protocol ContatoRepositorioProtocol {
    var lista: [Contato] { get }
    
    mutating func cadastrar(_ contato: Contato)
    mutating func listar() -> [Contato]
    mutating func alterar(_ contato: Contato, _ id: Int)
    mutating func remover(_ id: Int)
}

protocol ContatoServiceProtocol {
    mutating func menu()
    mutating func cadastrar()
    mutating func listar()
    mutating func alterar()
    mutating func remover()
}

// IMPLEMENTAÇÕES
struct ContatoRepositorio: ContatoRepositorioProtocol {
    private(set) var lista: [Contato] = []
    
    mutating func cadastrar(_ contato: Contato) {
        lista.append(contato)
    }
    
    func listar() -> [Contato] {
        return lista
    }
    
    mutating func alterar(_ contato: Contato, _ id: Int) {
        if let indice = lista.firstIndex(where: { $0.id == id }) {
            lista[indice] = contato
        }
    }
    
    mutating func remover(_ id: Int) {
        lista.removeAll(where: { $0.id == id })
    }
}

struct ContatoService: ContatoServiceProtocol {
    private var repositorio = ContatoRepositorio()
    private var proximoId: Int = 1
    
    mutating func menu() {
        var rodando = true
        
        while rodando {
            print("""
                \n--- Gerenciador de Contatos ---
                1. Cadastrar
                2. Listar
                3. Alterar
                4. Remover
                5. Sair
                Escolha uma opção:
                """, terminator: " ")
            
            if let opcao = readLine() {
                switch opcao {
                case "1":
                    cadastrar(); pausar()
                case "2":
                    listar(); pausar()
                case "3":
                    alterar(); pausar()
                case "4":
                    remover(); pausar()
                case "5":
                    print("Saindo...")
                    rodando = false
                default:
                    print("Opção inválida.")
                    pausar()
                }
            }
        }
    }
    
    mutating func cadastrar() {
        let dados = capturarDados()
        
        do {
            let novoContato = try validarContato(dados)
            repositorio.cadastrar(novoContato)
            proximoId += 1
            print("Contato cadastrado com sucesso!")
        } catch let erro as ErroContato {
            print("Erro de validação: \( erro.erroMensagem)")
        } catch {
            print("Ocorreu um erro inesperado: \(error.localizedDescription)")
        }
    }
    
    func listar() {
        let contatos = repositorio.listar()
            
        if contatos.isEmpty {
            print("\n--- A lista está vazia ---")
            return
        }

        print("\n--- Lista de Contatos ---")
        for contato in contatos {
            print("ID: \(contato.id) | Nome: \(contato.nome) | Idade: \(contato.idade) | Tel: \(contato.telefone) | Email: \(contato.email)")
        }
        print("-------------------------\n")
    }
    
    mutating func alterar() {
        let contatos = repositorio.listar()
        
        if contatos.isEmpty {
            print("Nenhum contato para alterar.")
            return
        }

        print("\n--- Selecione o contato pelo ID ---")
        for c in contatos {
            print("ID: \(c.id) - Nome: \(c.nome)")
        }
        
        print("\nDigite o ID:", terminator: " ")
        guard let id = Int(readLine() ?? ""), let contatoOriginal = contatos.first(where: { $0.id == id }) else {
            print("ID inválido!")
            return
        }

        print("\n--- Digite os novos dados ---")
        let novosDados = capturarDados(contatoOriginal)
        
        do {
            let contatoAtualizado = try validarContato(novosDados, id)
            repositorio.alterar(contatoAtualizado, id)
            print("\nContato atualizado com sucesso!")
        } catch let erro as ErroContato {
            print("\nErro de validação: \(erro.erroMensagem)")
        } catch {
            print("\nErro inesperado: \(error.localizedDescription)")
        }
    }
    
    mutating func remover() {
        let contatos = repositorio.listar()
        
        if contatos.isEmpty {
            print("A lista está vazia. Nada para remover.")
            pausar()
            return
        }

        print("\n--- Remoção de Contato ---")
        for c in contatos {
            print("ID: \(c.id) - Nome: \(c.nome)")
        }

        print("\nDigite o ID do contato que deseja remover:", terminator: " ")
        
        if let idTxt = readLine(), let id = Int(idTxt),
            contatos.contains(where: { $0.id == id }) {
            repositorio.remover(id)
            print("Contato removido com sucesso!")
        } else {
            print("\nCódigo inexistente!")
            return
        }
    }

    
    //---- Funções auxiliares
    private func pausar() {
        print("\nPressione ENTER para continuar...", terminator: "")
        _ = readLine()
    }
    
    private func capturarDados(_ atual: Contato? = nil) -> ContatoEntrada {
        print("Nome \(atual != nil ? "(\(atual!.nome))" : ""):")
        let nomeInput = readLine() ?? ""
        let nome = nomeInput.isEmpty && atual != nil ? atual!.nome : nomeInput

        print("Idade \(atual != nil ? "(\(atual!.idade))" : ""):")
        let idadeInput = readLine() ?? ""
        let idadeSrt = idadeInput.isEmpty && atual != nil ? String(atual!.idade) : idadeInput

        print("Telefone \(atual != nil ? "(\(atual!.telefone))" : ""):")
        let telInput = readLine() ?? ""
        let telefone = telInput.isEmpty && atual != nil ? atual!.telefone : telInput

        print("Email \(atual != nil ? "(\(atual!.email))" : ""):")
        let emailInput = readLine() ?? ""
        let email = emailInput.isEmpty && atual != nil ? atual!.email : emailInput
        
        return ContatoEntrada(nome, idadeSrt, telefone, email)
    }


    private func validarContato(_ dados: ContatoEntrada, _ id: Int? = nil) throws -> Contato {
        
        if (dados.nome.isEmpty || dados.idadeSrt.isEmpty || dados.telefone.isEmpty || dados.email.isEmpty) {
            throw ErroContato.campoVazio
        }
        
        if (repositorio.listar().contains(where: { $0.nome.lowercased() == dados.nome.lowercased() })) {
            throw ErroContato.nomeDuplicado
        }
        
        guard let idade = UInt(dados.idadeSrt) else {
            throw ErroContato.idadeInvalida
        }
        
        if !validaEmail(dados.email) {
            throw ErroContato.emailInvalido
        }
        
        let codigo = id ?? proximoId
        
        return Contato(codigo, dados.nome, UInt(idade), dados.telefone, dados.email)
    }
    
    private func validaEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicado = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicado.evaluate(with: email)
    }

}

// TRATAMENTO DE ERROS
enum ErroContato: LocalizedError {
    case campoVazio
    case nomeDuplicado
    case idadeInvalida
    case emailInvalido
    
    var erroMensagem: String {
        switch self {
            case .campoVazio: return "Por favor, preencha todos os campos."
            case .nomeDuplicado: return "Já existe um contato cadastrado com esse nome."
            case .idadeInvalida: return "Por favor, insira uma idade válida."
            case .emailInvalido: return "Por favor, insira um e-mail válido."
        }
    }
}

// INICIAR SISTEMA
var app = ContatoService()
app.menu()
