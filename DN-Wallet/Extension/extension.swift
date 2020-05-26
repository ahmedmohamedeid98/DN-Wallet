//
//  extension.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

// MARK:- UIViewController - NavBar Configuration
extension UIViewController {
    
    func configureNavigationBar(_ titleTintColor : UIColor = .white, backgoundColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3137254902, alpha: 1), tintColor: UIColor = .white, title: String, preferredLargeTitle: Bool = false) {
    if #available(iOS 13.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: titleTintColor]
        appearance.titleTextAttributes = [.foregroundColor: titleTintColor]
        appearance.backgroundColor = backgoundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.backgroundColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = tintColor
        navigationItem.title = title
    }
}}
//MARK:- UIView - layoutConstraint
extension UIView {
    
    func DNLayoutConstraint(_ top:NSLayoutYAxisAnchor? = nil, left:NSLayoutXAxisAnchor? = nil, right:NSLayoutXAxisAnchor? = nil, bottom:NSLayoutYAxisAnchor? = nil, margins:UIEdgeInsets = .zero, size: CGSize = .zero, centerH: Bool = false, centerV: Bool = false){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraintArray : [NSLayoutConstraint] = []
        
        if let top = top {
            constraintArray.append(topAnchor.constraint(equalTo: top, constant: margins.top))
        }
        if let left = left {
            constraintArray.append(leftAnchor.constraint(equalTo: left, constant: margins.left))
        }
        if let right = right {
            constraintArray.append(rightAnchor.constraint(equalTo: right, constant: -margins.right))
        }
        if let bottom = bottom {
            constraintArray.append(bottomAnchor.constraint(equalTo: bottom, constant: -margins.bottom))
        }
        if size.height != 0 {
            constraintArray.append(heightAnchor.constraint(equalToConstant: size.height))
        }
        if size.width != 0 {
            constraintArray.append(widthAnchor.constraint(equalToConstant: size.width))
        }
        if centerH {
            constraintArray.append(centerXAnchor.constraint(equalTo: superview!.centerXAnchor))
        }
        if centerV {
            constraintArray.append(centerYAnchor.constraint(equalTo: superview!.centerYAnchor))
        }
        
        NSLayoutConstraint.activate(constraintArray)
    }
    
    func DNLayoutConstraintFill(top: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, withSafeArea: Bool = true){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if withSafeArea {
            self.topAnchor.constraint(equalTo: (superview?.safeAreaLayoutGuide.topAnchor)!, constant: top).isActive = true
            self.leftAnchor.constraint(equalTo: (superview?.safeAreaLayoutGuide.leftAnchor)!, constant: left).isActive = true
            self.rightAnchor.constraint(equalTo: (superview?.safeAreaLayoutGuide.rightAnchor)!, constant: -right).isActive = true
            self.bottomAnchor.constraint(equalTo: (superview?.safeAreaLayoutGuide.bottomAnchor)!, constant: -bottom).isActive = true
        }else {
            self.topAnchor.constraint(equalTo: (superview?.topAnchor)!, constant: top).isActive = true
            self.leftAnchor.constraint(equalTo: (superview?.leftAnchor)!, constant: left).isActive = true
            self.rightAnchor.constraint(equalTo: (superview?.rightAnchor)!, constant: -right).isActive = true
            self.bottomAnchor.constraint(equalTo: (superview?.bottomAnchor)!, constant: -bottom).isActive = true
        }
        
    }
    
    func addShadow(color: CGColor = UIColor.black.cgColor , opacity: Float = 1, offset: CGSize = CGSize(width: 1, height: 1), redius: CGFloat = 0) {
        self.backgroundColor = .white
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = redius
    }
    
    func addBorder(color: CGColor = UIColor.lightGray.cgColor, width: CGFloat = 0.5, withCornerRaduis: Bool = false, reduis: CGFloat = 0) {
        self.layer.borderColor = color
        self.layer.borderWidth = width
        if withCornerRaduis {
            self.layer.cornerRadius = reduis
        }
    }
    
    func globalPoint() -> CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    
    
}

//MARK:- AppColor
extension UIColor {
    
    enum DN {
        case DarkBlue
        case LightBlue
        case DarkGray
        case LightGray
        case Black
        case White
        
        func color() -> UIColor {
            switch self {
            case .DarkBlue:
                return #colorLiteral(red: 0.167981714, green: 0.6728672981, blue: 0.9886779189, alpha: 1)
            case .LightBlue:
                return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            case .DarkGray:
                return #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            case .LightGray:
                return #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            case .Black:
                return #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            case .White:
                return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
    }
    static var DnTextColor: UIColor {
        return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    static var DnDarkBlue: UIColor {
        return  #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
    }
    static var DnBackgroundColor: UIColor {
        return .systemBackground//#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    static var DnBorderColor: UIColor {
        return #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
    }
    
    
    static var Mercury: UIColor {
        return UIColor(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    class var cantaloupe : UIColor {
            return UIColor(red:255/255, green:204/255, blue:102/255, alpha:1.0)
    }
    class func honeydew() -> UIColor {
        return UIColor(red:204/255, green:255/255, blue:102/255, alpha:1.0)
    }
    class func spindrift() -> UIColor {
        return UIColor(red:102/255, green:255/255, blue:204/255, alpha:1.0)
    }
    class func sky() -> UIColor {
        return UIColor(red:102/255, green:204/255, blue:255/255, alpha:1.0)
    }
    class func lavender() -> UIColor {
        return UIColor(red:204/255, green:102/255, blue:255/255, alpha:1.0)
    }
    class func carnation() -> UIColor {
        return UIColor(red:255/255, green:111/255, blue:207/255, alpha:1.0)
    }
    class func licorice() -> UIColor {
        return UIColor(red:0/255, green:0/255, blue:0/255, alpha:1.0)
    }
    class func snow() -> UIColor {
        return UIColor(red:255/255, green:255/255, blue:255/255, alpha:1.0)
    }
    class func salmon() -> UIColor {
        return UIColor(red:255/255, green:102/255, blue:102/255, alpha:1.0)
    }
    class func banana() -> UIColor {
        return UIColor(red:255/255, green:255/255, blue:102/255, alpha:1.0)
    }
    class func flora() -> UIColor {
        return UIColor(red:102/255, green:255/255, blue:102/255, alpha:1.0)
    }
    class func ice() -> UIColor {
        return UIColor(red:102/255, green:255/255, blue:255/255, alpha:1.0)
    }
    class func orchid() -> UIColor {
        return UIColor(red:102/255, green:102/255, blue:255/255, alpha:1.0)
    }
    class func bubblegum() -> UIColor {
        return UIColor(red:255/255, green:102/255, blue:255/255, alpha:1.0)
    }
    class var lead: UIColor {
        return UIColor(red:25/255, green:25/255, blue:25/255, alpha:1.0)
    }
    class func mercury() -> UIColor {
        return UIColor(red:230/255, green:230/255, blue:230/255, alpha:1.0)
    }
    class func tangerine() -> UIColor {
        return UIColor(red:255/255, green:128/255, blue:0/255, alpha:1.0)
    }
    class func lime() -> UIColor {
        return UIColor(red:128/255, green:255/255, blue:0/255, alpha:1.0)
    }
    class func seafoam() -> UIColor {
        return UIColor(red:0/255, green:255/255, blue:128/255, alpha:1.0)
    }
    class func aqua() -> UIColor {
        return UIColor(red:0/255, green:128/255, blue:255/255, alpha:1.0)
    }
    class func grape() -> UIColor {
        return UIColor(red:128/255, green:0/255, blue:255/255, alpha:1.0)
    }
    class func strawberry() -> UIColor {
        return UIColor(red:255/255, green:0/255, blue:128/255, alpha:1.0)
    }
    class func tungsten() -> UIColor {
        return UIColor(red:51/255, green:51/255, blue:51/255, alpha:1.0)
    }
    class func silver() -> UIColor {
        return UIColor(red:204/255, green:204/255, blue:204/255, alpha:1.0)
    }
    class func maraschino() -> UIColor {
        return UIColor(red:255/255, green:0/255, blue:0/255, alpha:1.0)
    }
    class func lemon() -> UIColor {
        return UIColor(red:255/255, green:255/255, blue:0/255, alpha:1.0)
    }
    class var spring: UIColor {
        return UIColor(red:0/255, green:255/255, blue:0/255, alpha:1.0)
    }
    class func turquoise() -> UIColor {
        return UIColor(red:0/255, green:255/255, blue:255/255, alpha:1.0)
    }
    class var blueberry: UIColor {
        return UIColor(red:0/255, green:0/255, blue:255/255, alpha:1.0)
    }
    class var magenta: UIColor {
        return UIColor(red:255/255, green:0/255, blue:255/255, alpha:1.0)
    }
    class var iron: UIColor {
        return UIColor(red:76/255, green:76/255, blue:76/255, alpha:1.0)
    }
    class var magnesium: UIColor {
        return UIColor(red:179/255, green:179/255, blue:179/255, alpha:1.0)
    }
    class var mocha: UIColor {
        return UIColor(red:128/255, green:64/255, blue:0/255, alpha:1.0)
    }
    class var fern: UIColor {
        return UIColor(red:64/255, green:128/255, blue:0/255, alpha:1.0)
    }
    class var moss: UIColor {
        return UIColor(red:0/255, green:128/255, blue:64/255, alpha:1.0)
    }
    class var ocean: UIColor {
        return UIColor(red:0/255, green:64/255, blue:128/255, alpha:1.0)
    }
    class var eggplant: UIColor {
        return UIColor(red:64/255, green:0/255, blue:128/255, alpha:1.0)
    }
    class var maroon: UIColor {
        return UIColor(red:128/255, green:0/255, blue:64/255, alpha:1.0)
    }
    class var steel: UIColor {
        return UIColor(red:102/255, green:102/255, blue:102/255, alpha:1.0)
    }
    class var aluminium: UIColor {
        return UIColor(red:153/255, green:153/255, blue:153/255, alpha:1.0)
    }
    class var cayenne: UIColor {
        return UIColor(red:128/255, green:0/255, blue:0/255, alpha:1.0)
    }
    class var asparagus : UIColor {
        return UIColor(red:128/255, green:120/255, blue:0/255, alpha:1.0)
    }
    class var clover: UIColor {
        return UIColor(red:0/255, green:128/255, blue:0/255, alpha:1.0)
    }
    class var teal: UIColor {
        return UIColor(red:0/255, green:128/255, blue:128/255, alpha:1.0)
    }
    class var midnight : UIColor {
        return UIColor(red:0/255, green:0/255, blue:128/255, alpha:1.0)
    }
    class var plum: UIColor {
        return UIColor(red:128/255, green:0/255, blue:128/255, alpha:1.0)
    }
    class var tin: UIColor {
        return UIColor(red:127/255, green:127/255, blue:127/255, alpha:1.0)
    }
    class var nickel : UIColor {
        return UIColor(red:128/255, green:128/255, blue:128/255, alpha:1.0)
    }
    
    class func randomColor(forChar char: Character) -> UIColor {
        let u_char = char.lowercased()
        switch u_char {
        case "a": return [nickel, .green, tin, midnight].randomElement()!
        case "b": return [cantaloupe, tin, plum, midnight].randomElement()!
        case "c": return [iron, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)].randomElement()!
        case "d": return [lead, #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)].randomElement()!
        case "e": return [tin, #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)].randomElement()!
        case "f": return [midnight, #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)].randomElement()!
        case "g": return [steel, #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)].randomElement()!
        case "h": return [aluminium, #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)].randomElement()!
        case "i": return [eggplant, #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)].randomElement()!
        case "j": return [spring, #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)].randomElement()!
        case "k": return [mocha, #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)].randomElement()!
        case "l": return [fern, #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)].randomElement()!
        case "m": return [moss, #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)].randomElement()!
        case "n": return [blueberry, #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)].randomElement()!
        case "o": return [ocean, #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)].randomElement()!
        case "p": return [magenta, #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)].randomElement()!
        case "q": return [nickel, #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1), #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1), #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)].randomElement()!
        case "r": return [nickel, #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)].randomElement()!
        case "s": return [nickel, #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1), #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1), #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)].randomElement()!
        case "t": return [nickel, #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)].randomElement()!
        case "u": return [nickel, #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1), #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)].randomElement()!
        case "v": return [nickel, #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)].randomElement()!
        case "w": return [nickel, #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1), #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1), #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)].randomElement()!
        case "x": return [nickel, #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1), #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)].randomElement()!
        case "y": return [nickel, #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)].randomElement()!
        default:
            return [clover, teal, asparagus, cayenne].randomElement()!
        }
    }
    
}


//MARK:- AppFont
extension UIFont {
    enum DN {
        case Bold
        case SemiBlod
        case Regular
        case Light
        
        func font(size: CGFloat = 20) -> UIFont {
            switch self {
                
            case .Bold:
                return .systemFont(ofSize: size, weight: .bold)
            case .SemiBlod:
                return .systemFont(ofSize: size, weight: .semibold)
            case .Regular:
                return .systemFont(ofSize: size, weight: .regular)
            case .Light:
                return .systemFont(ofSize: size, weight: .light)
            }
        
        }

    }
}

extension UITextField {
    
    func stopSmartActions(){
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.smartDashesType = .no
        self.smartInsertDeleteType = .no
        self.smartQuotesType = .no
        self.spellCheckingType = .no
    }
    func basicConfigure(fontSize: CGFloat = 16) {
        self.font = UIFont.DN.Regular.font(size: fontSize)
        self.textColor = UIColor.DN.DarkBlue.color()
    }
    
    func leftPadding(text: String? = nil, textColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), width: CGFloat = 5) {
        if let txt = text {
            let paddingView = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
            paddingView.text = txt
            paddingView.textColor = textColor
            paddingView.font = UIFont.DN.Regular.font(size: 12)
            self.leftView = paddingView
        } else {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
            self.leftView = paddingView
        }
        self.leftViewMode = .always
    }
    
    func rightPadding(image: UIImage? = nil, imgTintColor: UIColor? = nil, text:String? = nil, width: CGFloat = 0) {
        if image != nil {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = image
            if let color = imgTintColor {
                imageView.tintColor = color
            } else {
                imageView.tintColor = .black
            }
            paddingView.addSubview(imageView)
            imageView.DNLayoutConstraint(paddingView.topAnchor, left: paddingView.rightAnchor, right: paddingView.rightAnchor, bottom: paddingView.bottomAnchor, margins: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
            self.rightView = paddingView
        } else if text != nil {
            let paddingView = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
            paddingView.text = text
            paddingView.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            paddingView.font = UIFont.DN.Regular.font(size: 12)
            self.rightView = paddingView
        }else {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
            self.rightView = paddingView
        }
        self.rightViewMode = .always
    }
    
    func setBottomBorder(color: CGColor = UIColor.DN.DarkBlue.color().cgColor, offset: CGSize = CGSize(width: 0, height: 0.5)) {
        self.backgroundColor = .white
        self.layer.shadowColor = color
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
extension UILabel {
    func basicConfigure(fontSize: CGFloat = 16) {
        self.font = UIFont.DN.Regular.font(size: fontSize)
        self.textColor = .DnDarkBlue
    }
}

extension UIStackView {
    func configureStack(axis: NSLayoutConstraint.Axis , distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, space: CGFloat) {
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = space
    }
}

extension UITableView {
    func updateRowWith(indexPaths: [IndexPath], animate: UITableView.RowAnimation) {
            self.beginUpdates()
            self.reloadRows(at: indexPaths, with: animate)
            self.endUpdates()
    }
}


extension UIButton {
    func enable() {
        self.isHighlighted = false
        self.isEnabled = true
    }
    func disable() {
        self.isHighlighted = true
        self.isEnabled = false
    }
}
