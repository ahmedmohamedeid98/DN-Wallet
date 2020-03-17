

struct HCard {
    var email: String
    var amount: String
    var currancy: Int
    private(set) var date: Date
    
    init(email: String, amount: String, currancy: Int) {
        self.email = email
        self.amount = amount
        self.currancy = currancy
        self.date = Date()
    }
    
}
