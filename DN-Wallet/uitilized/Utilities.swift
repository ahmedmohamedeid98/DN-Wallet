





import Foundation

class Utile {
    class var currentDate: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let result = formatter.string(from: date)
        return result
    }
}


//MARK:- Constant

let navBARColor = UIColor.DnColor
let navBARTitleFont = UIFont.DN.SemiBlod.font(size: 18)
let navBARTitleColor = UIColor.DnWhiteColor
