
/*
 {
     "consumption": 30,
     "recevie": 0,
     "donate": 0,
     "_id": "5f2eda4685540a0017e62cc9",
     "send": 30,
     "accountOwner": "5f2b12e453e9f500178c3328",
     "result": [
         {
             "_id": "5f2ee240d2d30c001764f34e",
             "id": "5f2afe4dc2d29b001746edf7",
             "email": "karim@gmail.com",
             "amount": 20,
             "currencuy_code": "EGP",
             "date": "2020-08-08T17:34:56.936Z",
             "category": "1",
             "inner_category": "0"
         },
         {
             "_id": "5f2eda4685540a0017e62cca",
             "id": "5f2afe23c2d29b001746edf6",
             "email": "elraghy8@gmail.com",
             "amount": 10,
             "currencuy_code": "EGP",
             "date": "2020-08-08T17:00:54.247Z",
             "category": "1",
             "inner_category": "0"
         }
     ],
     "__v": 1
 }
 **/
struct History: Codable {
    let consumption: Int
    let recevie: Int
    let donate: Int
    let result: [HistoryCategory]
    
}

struct HistoryCategory: Codable {
    let email: String
    let amount: Int
    let currencuy_code: String
    let date: String
    let category: String
    let inner_category: String
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
