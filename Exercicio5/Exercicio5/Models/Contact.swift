import Foundation

struct Contact: Identifiable, Codable {
    let id: String?
    var nome: String
    var email: String
    var telefone: String
    var nascimento: String
    var cep: String
    var bairro: String
    var logradouro: String
    var numero: String
    var estado: String
    var cidade: String
}

struct ViaCEPResponse: Decodable {
    let cep: String
    let logradouro: String
    let bairro: String
    let localidade: String
    let uf: String
}
