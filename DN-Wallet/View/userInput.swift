//
//  userInput.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class userInput: UIView {

    let image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "mail")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    let seperatorLine: UIView = {
        let sepLine = UIView()
        sepLine.backgroundColor = .gray
        return sepLine
    }()
    
    let textField: UITextField = {
        let txtField = UITextField()
        txtField.font = UIFont(name: "Monlo", size: 10)
        txtField.minimumFontSize = 9.0
        txtField.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        txtField.autocapitalizationType = .none
        txtField.autocorrectionType = .no
        return txtField
    }()
    
    func configureInputField(imageName: String, placeholder: String, isSecure: Bool) {
        self.image.image = UIImage(named: imageName)
        self.textField.placeholder = placeholder
        self.textField.isSecureTextEntry = isSecure
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("inf")
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        print("inter")
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //self.layer.cornerRadius = 20.0
        setupViewConstraints()
    }
    
    func setupViewConstraints() {
        addSubview(image)
        addSubview(seperatorLine)
        addSubview(textField)
        
        image.constraints(self.topAnchor , left: self.leftAnchor, right: nil, bottom: self.bottomAnchor, margins: UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 0), size: CGSize(width: 30.0, height: 30.0))
        seperatorLine.constraints(self.topAnchor, left: image.rightAnchor, right: nil, bottom: bottomAnchor, margins: UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 0), size: CGSize(width: 0.5, height: 32))
        textField.constraints(self.topAnchor, left: seperatorLine.rightAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, margins: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4), size: .zero)
    }
    
    
    
}
