
struct History: Codable {
    let consumption: Double
    let recive: Double
    let donation: Double
    let result: [HistoryCategory]
    
}

struct HistoryCategory: Codable {
    let id: String
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
