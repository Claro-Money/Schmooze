import Foundation


extension Dictionary where Key == String, Value == String {
    
    func asFormattedText() -> String? {
        var string = ""
        for key in keys {
            let value = self[key]
            string += "\(key): \(value ?? NA)\n"
        }
        return string.isEmpty ? nil : string
    }
    
}
