







//MARK:- Constant

let navBARColor = UIColor.DN.DarkBlue.color()
let navBARTitleFont = UIFont.DN.SemiBlod.font(size: 18)
let navBARTitleColor = UIColor.DN.White.color()

class Utilities {
    static var currentData: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-mm-yyyy"
        let result = formatter.string(from: date)
        return result
    }
}
