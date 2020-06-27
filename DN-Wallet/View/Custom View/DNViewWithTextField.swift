//
//  DNViewWithTextField.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNViewWithTextField: UIView {

    
    let image           = DNImageView(tintColor: .DnGrayColor)
    let textField       = DNTextField()
    let seperatorLine   = DNSeperatorLine()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configure(imageName: String, placeholder: String, systemImage: Bool = false, isSecure: Bool = false) {
        systemImage ? (self.image.systemTitle = imageName) : (self.image.assetsTitle = imageName)
        self.textField.placeholder = placeholder
        self.textField.isSecureTextEntry = isSecure
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView() {
        backgroundColor = .DnCellColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.DnGrayColor.cgColor
        self.layer.cornerRadius = 4
        setupViewConstraints()
    }
    
    private func setupViewConstraints() {
        addSubview(image)
        addSubview(seperatorLine)
        addSubview(textField)
        image.DNLayoutConstraint(left: leftAnchor,
                                 margins: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0),
                                 size: CGSize(width: 30.0, height: 30.0),
                                 centerV: true)
        seperatorLine.DNLayoutConstraint(left: image.rightAnchor,
                                         margins: UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 0),
                                         size: CGSize(width: 0.5, height: 30),
                                         centerV: true)
        textField.DNLayoutConstraint(topAnchor,
                                     left: seperatorLine.rightAnchor,
                                     right: rightAnchor,
                                     bottom: bottomAnchor,
                                     margins: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 4),
                                     size: .zero)
    }
    
}
