import SwiftUI

struct AddDespesaView: View {

    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss

    var mes: String
    
    @StateObject var vm = AddDespesaViewModel()

    var body: some View {
        VStack(spacing: 25) {

            Spacer()

            Text("Nova Despesa")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Mês: \(mes)")
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 8) {
                Text("Categoria")
                    .font(.caption)
                    .foregroundColor(.gray)

                Picker("", selection: $vm.categoria) {
                    ForEach(Categoria.allCases, id: \.self) { cat in
                        Text(cat.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 8) {
                Text("Valor")
                    .font(.caption)
                    .foregroundColor(.gray)

                TextField("Ex: 150.00", text: $vm.valor)
                    .keyboardType(.decimalPad)
                    .font(.title3)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            if !vm.errorMessage.isEmpty {
                Text(vm.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()

            Button {
                vm.salvar(context: context, mes: mes) {
                    dismiss()
                }
            } label: {
                Text("Salvar Despesa")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }

        }
        .padding()
    }
}
