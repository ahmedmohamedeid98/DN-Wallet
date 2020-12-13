//
//  UITextField+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension UITextField {
    
    func doNotShowTheKeyboard() {
        //It will hide keyboard
        self.inputView = UIView()
        //It will hide keyboard tool bar
        self.inputAccessoryView = UIView()
        //it will hide the cursor
        self.tintColor = .DnCellColor
    }
    
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
