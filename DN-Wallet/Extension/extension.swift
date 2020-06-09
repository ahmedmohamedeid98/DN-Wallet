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
    
    func configureNavigationBar(_ titleTintColor : UIColor = .white, backgoundColor: UIColor = .DnColor, tintColor: UIColor = .white, title: String, preferredLargeTitle: Bool = false) {
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
    
    static var DnGrayColor: UIColor {
        return .systemGray2
    }
    static var DnWhiteColor: UIColor {
        return .white
    }
    static var DnColor: UIColor {
        return #colorLiteral(red: 0.1782214642, green: 0.4982336164, blue: 0.757638514, alpha: 1)
    }
    static var DnVcBackgroundColor: UIColor {
        return UIColor(named: "Dynamic-Background") ?? UIColor.gray
    }
    static var DnCellColor: UIColor {
        return UIColor(named: "Dynamic-Cell") ?? UIColor.gray
    }
    
    static var DnTextColor: UIColor {
        return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    static var DnDarkBlue: UIColor {
        return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    static var DnBackgroundColor: UIColor {
        return .systemGroupedBackground
    }
    static var DnBorderColor: UIColor {
        return #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
    }
    
    class func randomColor(forChar char: Character) -> UIColor {
        let u_char = char.lowercased()
        switch u_char {
        case "a": return #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
        case "b": return #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        case "c": return #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case "d": return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case "e": return #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        case "f": return #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        case "g": return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        case "h": return #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
        case "i": return #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
        case "j": return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        case "k": return #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
        case "l": return #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        case "m": return #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        case "n": return #colorLiteral(red: 0.2549019608, green: 0.6117647059, blue: 1, alpha: 1)
        case "o": return #colorLiteral(red: 0.6352941176, green: 0.6352941176, blue: 0.6549019608, alpha: 1)
        case "p": return #colorLiteral(red: 0.3882352941, green: 0.3803921569, blue: 0.9490196078, alpha: 1)
        case "q": return #colorLiteral(red: 0.431372549, green: 0.862745098, blue: 1, alpha: 1)
        case "r": return #colorLiteral(red: 0.8, green: 0.3960784314, blue: 1, alpha: 1)
        case "s": return #colorLiteral(red: 1, green: 0.2549019608, blue: 0.4117647059, alpha: 1)
        case "t": return #colorLiteral(red: 0.7137254902, green: 0.5960784314, blue: 0.4470588235, alpha: 1)
        case "u": return #colorLiteral(red: 1, green: 0.8784313725, blue: 0.07843137255, alpha: 1)
        case "v": return #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
        case "w": return #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
        case "x": return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case "y": return #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        default:
            return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
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
        self.textColor = .DnTextColor
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
    
    func setBottomBorder(color: CGColor = UIColor.DnColor.cgColor, offset: CGSize = CGSize(width: 0, height: 0.5)) {
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
