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
    
func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
    if #available(iOS 13.0, *) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor
        navBarAppearance.shadowColor = nil


        /*
         navBarAppearance.configureWithOpaqueBackground()
         navBarAppearance.backgroundColor = UIColor."YourColor"
         navBarAppearance.shadowColor = nil
         */
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
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
