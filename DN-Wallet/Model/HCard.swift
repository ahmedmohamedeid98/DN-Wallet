

struct HCard {
    private(set) var email: String
    private(set) var amount: String
    private(set) var currancy: Currency
    private(set) var date: String
        
    
    init(email: String, amount: String, currancy: Currency) {
        self.email = email
        self.amount = "\(amount) \(currancy.symbole() ?? "")"
        self.currancy = currancy
        self.date = Date().toString()
    }
    
}

extension Date {
    func toString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .full
        dateformatter.timeStyle = .short
        return dateformatter.string(from: self)
    }
}
