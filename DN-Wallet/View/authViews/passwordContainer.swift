//
//  passwordContainer.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/12/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class passwordContainer: UIView {

    //MARK:- Properities
    private var showPasswordBtn = UIButton(type: .system)
    private var eyeImage = SAImageView(title: "eye", tintColor: .gray, contentMode: .scaleAspectFit, isSystemImage: true)
    private var toggleShow: Bool = true
    var textField = DNTextField(placeholder: "Password", stopSmartActions: true, isSecure: true)
    var text: String? { return textField.text }
    
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        textField.placeholder = placeholder
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Configure View
    private func configureTextField() {
        addSubview(textField)
        textField.DNLayoutConstraint(topAnchor, left: leftAnchor, right: showPasswordBtn.leftAnchor, bottom: bottomAnchor, margins: .zero, size: .zero)
    }
    private func configureShowToggleButton() {
        showPasswordBtn.addTarget(self, action: #selector(toggleImage), for: .touchUpInside)
        addSubview(showPasswordBtn)
        showPasswordBtn.DNLayoutConstraint(eyeImage.topAnchor, left: eyeImage.leftAnchor, right: eyeImage.rightAnchor, bottom: eyeImage.bottomAnchor)
    }
    
    private func configureEyeImage() {
        addSubview(eyeImage)
        eyeImage.DNLayoutConstraint(topAnchor, left: nil, right: rightAnchor, bottom: bottomAnchor, margins: .zero, size: CGSize(width: 30, height: 0))
    }
    
    private func configure() {
        configureEyeImage()
        configureShowToggleButton()
        configureTextField()
    }
    
    @objc private func toggleImage() {
        
        if toggleShow {
            eyeImage.image = UIImage(systemName: "eye.slash")
            textField.isSecureTextEntry = false
            toggleShow = false
        }else {
            eyeImage.image = UIImage(systemName: "eye")
            textField.isSecureTextEntry = true
            toggleShow = true
            print("it is secure password")
        }
    }
}
