
struct History: Codable {
    let consumption: Double
    let receive: Double
    let donation: Double
    let result: [HistoryCategory]
    
}

struct HistoryCategory: Codable {
    let email: String
    let amount: Double
    let currency: String
    let date: String
    let category: Int
    let innerCategory: Int
    
    enum CondingKeys : String, CodingKey {
        case id
        case email
        case amount
        case currency = "currency_code"
        case date
        case category
        case innerCategory = "inner_category"
    }
}

enum Category: Int {
    case send
    case receive
    case donation
    
    var identifier: Int {
        return self.rawValue
    }
    var str: String {
        switch self {
        case .send: return "Send"
        case .receive: return "Receive"
        case .donation: return "Donation"
        @unknown default: return "unknown"
        }
    }
}

enum InnerCategory: Int {
    case individuals
    case other
    
    var identitfer: Int {
        return self.rawValue
    }
}
