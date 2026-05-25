import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContactViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.contacts.isEmpty {
                    ProgressView("Buscando contatos...")
                } else if viewModel.contacts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("Nenhum contato cadastrado")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Toque no botão + para adicionar.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(viewModel.contacts) { contact in
                            NavigationLink(destination: ContactFormView(viewModel: viewModel, contactToEdit: contact)) {
                                ContactRowView(contact: contact)
                            }
                        }
                        .onDelete(perform: viewModel.deleteContact)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Contatos API")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ContactFormView(viewModel: viewModel)) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                viewModel.fetchContacts()
            }
        }
    }
}


#Preview {
    ContentView()
}
