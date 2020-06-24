//
//  UIView+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

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
    /*
    func globalPoint() -> CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }*/
   
}
