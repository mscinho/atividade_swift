import SwiftUI

struct RegisterView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm = RegisterViewModel()

    var body: some View {
        VStack(spacing: 20) {

            Text("Criar Conta")
                .font(.title)
                .fontWeight(.bold)

            TextField("Nome", text: $vm.nome)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            TextField("Email", text: $vm.email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            SecureField("Senha", text: $vm.senha)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Button {
                vm.cadastrar(context: context)
            } label: {
                Text("Cadastrar")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if !vm.errorMessage.isEmpty {
                Text(vm.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
        .onChange(of: vm.sucesso) { sucesso in
            if sucesso {
                dismiss()
            }
        }
    }
}
