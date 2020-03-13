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
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.tintColor = UIColor.DN.DarkGray.color()
        return img
    }()
    
    let seperatorLine: UIView = {
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor.DN.DarkGray.color()
        return sepLine
    }()
    
    let textField: UITextField = {
        let txtField = UITextField()
        txtField.font = UIFont.DN.Light.font(size: 14)
        txtField.minimumFontSize = 9.0
        txtField.textColor = UIColor.DN.DarkGray.color()
        txtField.stopSmartActions()
        return txtField
    }()
    
    func configureInputField(imageName: String, systemImage: Bool = false, placeholder: String, isSecure: Bool) {
        if systemImage {
            self.image.image = UIImage(systemName: imageName)
        }else {
            self.image.image = UIImage(named: imageName)
        }
        self.textField.placeholder = placeholder
        self.textField.isSecureTextEntry = isSecure
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.DN.LightGray.color().cgColor
        self.layer.cornerRadius = 4
        setupViewConstraints()
    }
    
    func setupViewConstraints() {
        addSubview(image)
        addSubview(seperatorLine)
        addSubview(textField)
        
        image.DNLayoutConstraint(self.topAnchor , left: self.leftAnchor, right: nil, bottom: self.bottomAnchor, margins: UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 0), size: CGSize(width: 30.0, height: 30.0))
        seperatorLine.DNLayoutConstraint(self.topAnchor, left: image.rightAnchor, right: nil, bottom: bottomAnchor, margins: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 0), size: CGSize(width: 0.5, height: 0))
        textField.DNLayoutConstraint(self.topAnchor, left: seperatorLine.rightAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, margins: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4), size: .zero)
    }
    
    
    
}
