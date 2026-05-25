import SwiftUI

struct ContactFormView: View {
    @ObservedObject var viewModel: ContactViewModel
    @Environment(\.dismiss) var dismiss
    
    var contactToEdit: Contact?
    
    @State private var nome = ""
    @State private var email = ""
    @State private var telefone = ""
    @State private var nascimento = ""
    @State private var cep = ""
    @State private var bairro = ""
    @State private var logradouro = ""
    @State private var numero = ""
    @State private var estado = ""
    @State private var cidade = ""
    
    var body: some View {
        Form {
            Section(header: Text("Dados Pessoais")) {
                HStack {
                    Image(systemName: "person").foregroundColor(.blue)
                    TextField("Nome Completo", text: $nome)
                }
                HStack {
                    Image(systemName: "envelope").foregroundColor(.blue)
                    TextField("E-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                HStack {
                    Image(systemName: "phone").foregroundColor(.blue)
                    TextField("Telefone", text: $telefone)
                        .keyboardType(.phonePad)
                        .onChange(of: telefone) { oldValue, newValue in
                            telefone = newValue.formattingAsPhone()
                        }
                }
                HStack {
                    Image(systemName: "calendar").foregroundColor(.blue)
                    TextField("Nascimento (DD/MM/AAAA)", text: $nascimento)
                        .onChange(of: nascimento) { oldValue, newValue in
                            nascimento = newValue.formattingAsDate()
                        }
                }
            }
            
            Section(header: Text("Endereço")) {
                HStack {
                    Image(systemName: "text.magnifyingglass").foregroundColor(.blue)
                    TextField("CEP (Digite 8 números)", text: $cep)
                        .keyboardType(.numberPad)
                        .onChange(of: cep) { oldValue, newValue in
                            if newValue.count == 8 {
                                viewModel.searchCEP(newValue) { address in
                                    self.bairro = address.bairro
                                    self.logradouro = address.logradouro
                                    self.estado = address.uf
                                    self.cidade = address.localidade
                                }
                            }
                        }
                }
                TextField("Logradouro", text: $logradouro)
                TextField("Bairro", text: $bairro)
                TextField("Número", text: $numero)
                TextField("Cidade", text: $cidade)
                TextField("Estado", text: $estado)
            }
            
            Button(action: saveContact) {
                Text(contactToEdit == nil ? "Cadastrar Contato" : "Atualizar Contato")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue.gradient)
                    .cornerRadius(8)
            }
            .listRowBackground(Color.clear)
            .padding(.top, 10)
        }
        .navigationTitle(contactToEdit == nil ? "Novo Contato" : "Editar Contato")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let contact = contactToEdit {
                nome = contact.nome; email = contact.email; telefone = contact.telefone
                nascimento = contact.nascimento; cep = contact.cep; bairro = contact.bairro
                logradouro = contact.logradouro; numero = contact.numero; estado = contact.estado; cidade = contact.cidade
            }
        }
    }
    
    private func saveContact() {
        let contact = Contact(
            id: contactToEdit?.id, nome: nome, email: email, telefone: telefone,
            nascimento: nascimento, cep: cep, bairro: bairro, logradouro: logradouro,
            numero: numero, estado: estado, cidade: cidade
        )
        
        if contactToEdit == nil {
            viewModel.createContact(contact: contact) { dismiss() }
        } else {
            viewModel.updateContact(contact: contact) { dismiss() }
        }
    }
}
