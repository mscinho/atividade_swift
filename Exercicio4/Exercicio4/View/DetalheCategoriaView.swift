import SwiftUI
import CoreData

struct DetalheCategoriaView: View {

    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss

    var categoria: String
    var mes: String

    @StateObject var vm = DetalheCategoriaViewModel()

    @State private var mostrarEditar = false
    @State private var despesaSelecionada: Despesa?
    @State private var novoValor = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.despesas, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text("R$ \(item.valor, specifier: "%.2f")")
                            .font(.headline)

                        Text(item.data ?? Date(), style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // EXCLUIR (direita → esquerda)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            if let index = vm.despesas.firstIndex(of: item) {
                                vm.deletar(at: IndexSet(integer: index),
                                           context: context,
                                           categoria: categoria,
                                           mes: mes)
                            }
                        } label: {
                            Label("Excluir", systemImage: "trash")
                        }
                    }

                    // EDITAR (esquerda → direita)
                    .swipeActions(edge: .leading) {
                        Button {
                            despesaSelecionada = item
                            novoValor = String(item.valor)
                            mostrarEditar = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                    
                }
            }
            .navigationTitle(categoria)
            .toolbar {
                Button("Fechar") {
                    dismiss()
                }
            }
            .onAppear {
                vm.carregar(context: context,
                            categoria: categoria,
                            mes: mes)
            }

            .alert("Editar Valor", isPresented: $mostrarEditar) {
                TextField("Novo valor", text: $novoValor)
                    .keyboardType(.decimalPad)

                Button("Salvar") {
                    if let valor = Double(novoValor),
                       let despesa = despesaSelecionada {

                        vm.editar(despesa: despesa,
                                  novoValor: valor,
                                  context: context,
                                  categoria: categoria,
                                  mes: mes)
                    }
                }

                Button("Cancelar", role: .cancel) { }

            } message: {
                Text("Atualize o valor da despesa")
            }
        }
    }
}
