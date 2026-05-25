import Foundation

extension String {
    // Máscara de Telefone: (XX) XXXXX-XXXX ou (XX) XXXX-XXXX
    func formattingAsPhone() -> String {
        let numbers = self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        let maxDigits = min(numbers.count, 11)
        let subNumbers = numbers.prefix(maxDigits)
        
        for ch in subNumbers {
            if result.count == 0 {
                result.append("(")
            } else if result.count == 3 {
                result.append(") ")
            } else if result.count == 9 && maxDigits == 10 {
                result.append("-")
            } else if result.count == 10 && maxDigits == 11 {
                result.append("-")
            }
            result.append(ch)
        }
        return result
    }
    
    // Máscara de Data: DD/MM/AAAA
    func formattingAsDate() -> String {
        let numbers = self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        var result = ""
        
        let subNumbers = numbers.prefix(8)
        
        for ch in subNumbers {
            if result.count == 2 || result.count == 5 {
                result.append("/")
            }
            result.append(ch)
        }
        return result
    }
}
