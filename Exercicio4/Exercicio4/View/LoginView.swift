import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) var context
    @StateObject var vm = LoginViewModel()

    @State private var mostrarCadastro = false

    var body: some View {
        if vm.isLogged {
            DashboardView()
        } else {
            VStack(spacing: 25) {

                Spacer()

                Text("Bem-vindo")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Faça login para continuar")
                    .foregroundColor(.gray)

                VStack(spacing: 15) {

                    TextField("Email", text: $vm.email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Senha", text: $vm.senha)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                Button(action: {
                    vm.login(context: context)
                }) {
                    Text("Entrar")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button("Criar conta") {
                    mostrarCadastro = true
                }
                .font(.footnote)
                .foregroundColor(.blue)

                Spacer()
            }
            .padding()
            .sheet(isPresented: $mostrarCadastro) {
                RegisterView()
            }
        }
    }
}
