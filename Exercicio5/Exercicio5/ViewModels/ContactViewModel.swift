
import Foundation
import Combine

class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var isLoading = false
    
    private let baseURL = "http://localhost:3000/contatos"
    
    func fetchContacts() {
        guard let url = URL(string: baseURL) else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async { self.isLoading = false }
            guard let data = data else { return }
            if let decoded = try? JSONDecoder().decode([Contact].self, from: data) {
                DispatchQueue.main.async {
                    self.contacts = decoded
                }
            }
        }.resume()
    }
    
    func createContact(contact: Contact, completion: @escaping () -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(contact)
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    self.fetchContacts()
                    completion()
                }
            }
        }.resume()
    }
    
    func updateContact(contact: Contact, completion: @escaping () -> Void) {
        guard let id = contact.id, let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(contact)
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.fetchContacts()
                    completion()
                }
            }
        }.resume()
    }
    
    func deleteContact(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let contact = contacts[index]
            guard let id = contact.id, let url = URL(string: "\(baseURL)/\(id)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { _, response, _ in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                    DispatchQueue.main.async {
                        self.contacts.remove(at: index)
                    }
                }
            }.resume()
        }
    }
    
    func searchCEP(_ cep: String, completion: @escaping (ViaCEPResponse) -> Void) {
        let cleanCEP = cep.replacingOccurrences(of: "-", with: "")
        guard cleanCEP.count == 8 else { return }
        
        var componentes = URLComponents()
        componentes.scheme = "https"
        componentes.host = "viacep.com.br"
        componentes.path = "/ws/\(cleanCEP)/json/"
        
        guard let url = componentes.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            if let address = try? JSONDecoder().decode(ViaCEPResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(address)
                }
            }
        }.resume()
    }

}
