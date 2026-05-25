import SwiftUI

struct ContactRowView: View {
    let contact: Contact
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(String(contact.nome.prefix(1)).uppercased())
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.blue.gradient))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.nome)
                    .font(.body)
                    .fontWeight(.medium)
                
                HStack(spacing: 4) {
                    Image(systemName: "envelope")
                    Text(contact.email)
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                    Text("\(contact.logradouro), \(contact.numero) - \(contact.cidade)/\(contact.estado)")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}
