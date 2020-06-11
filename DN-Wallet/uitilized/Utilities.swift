





import Foundation

// static data
let currencyData: [PopMenuItem] = [PopMenuItem(image: nil, title: "Egyption Pound", code: "EGP"),
                                   PopMenuItem(image: nil, title: "American Dollar", code: "USD"),
                                   PopMenuItem(image: nil, title: "Euro", code: "EUR"),
                                   PopMenuItem(image: nil, title: "Saudi Riyal", code: "SAR")
]
let countryData: [PopMenuItem] = [PopMenuItem(image: nil, title: "Egypt", code: "+20"),
                                  PopMenuItem(image: nil, title: "United State", code: "+43"),
                                  PopMenuItem(image: nil, title: "Saudi Arab", code: "+86"),
                                  PopMenuItem(image: nil, title: "Iraq", code: "+28")]

let creditCardData: [PopMenuItem] = [PopMenuItem(image: nil, title: "Maser Card", code: nil),
                                     PopMenuItem(image: nil, title: "Vesa", code: nil),
                                     PopMenuItem(image: nil, title: "Meza", code: nil)]

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
