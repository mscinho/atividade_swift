import SwiftUI
import CoreData
import Charts

struct DashboardView: View {

    @Environment(\.managedObjectContext) var context
    @StateObject var vm = DashboardViewModel()

    @State private var mesSelecionado = Mes.janeiro.rawValue
    @State private var mostrarAdd = false
    @State private var categoriaSelecionada = ""
    @State private var mostrarDetalhe = false

    let meses = Mes.allCases.map { $0.rawValue }

    var body: some View {
        NavigationView {
            ScrollView {

                VStack(spacing: 20) {

                    Text("Olá, \(vm.nomeUsuario)")
                        .font(.title2)
                        .fontWeight(.bold)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(meses, id: \.self) { mes in

                                Text(mes)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        mesSelecionado == mes
                                        ? Color.blue
                                        : Color(.systemGray5)
                                    )
                                    .foregroundColor(
                                        mesSelecionado == mes
                                        ? .white
                                        : .black
                                    )
                                    .cornerRadius(20)
                                    .animation(.easeInOut, value: mesSelecionado)
                                    .onTapGesture {
                                        mesSelecionado = mes
                                        vm.carregar(context: context, mes: mes)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Chart(vm.chartData(), id: \.categoria) { item in
                        SectorMark(angle: .value("Valor", item.valor))
                            .foregroundStyle(by: .value("Categoria", item.categoria))
                    }
                    .frame(height: 250)

                    Text("Total: R$ \(vm.total(), specifier: "%.2f")")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Ranking de Gastos")
                            .font(.headline)

                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(vm.ranking(), id: \.categoria) { item in
                                    Button {
                                        categoriaSelecionada = item.categoria
                                        mostrarDetalhe = true
                                    } label: {
                                        HStack {
                                            Text(item.categoria)
                                            Spacer()
                                            Text("R$ \(item.valor, specifier: "%.2f")")
                                                .fontWeight(.bold)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 250)
                        
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.logout(context: context)
                    } label: {
                        Image(systemName: "power")
                            .foregroundColor(.red)
                    }
                }
            }
            
            .sheet(isPresented: $mostrarAdd, onDismiss: {
                vm.carregar(context: context, mes: mesSelecionado)
            }) {
                AddDespesaView(mes: mesSelecionado)
            }
            
            .sheet(isPresented: $mostrarDetalhe, onDismiss: {
                vm.carregar(context: context, mes: mesSelecionado)
            }) {
                DetalheCategoriaView(categoria: categoriaSelecionada, mes: mesSelecionado)
            }

            .onAppear {
                vm.buscarUsuario(context: context)
                vm.carregar(context: context, mes: mesSelecionado)
            }
        }
    }
}
