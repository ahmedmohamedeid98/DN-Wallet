//
//  DNEditView.swift
//  DN-Wallet
//
//  Created by Mac OS on 8/12/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNEditView: UIView {
    
    let titleLabel          = DNTitleLabel(textAlignment: .center, fontSize: 18)
    let currentValueLabel   = DNSecondaryTitleLabel(fontSize: 16)
    let editButton          = DNButton(backgroundColor: .white, title: "Edit", cornerRedii: 22)
    let textField           = DNTextField(placeholder: "Enter new vlaue", keyboardType: .default, stopSmartActions: true, isSecure: false)
    
    
    private func configureEditButton() {
        editButton.layer.borderColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).cgColor
        editButton.layer.borderWidth = 2
    }
    
    private func configureTitleLabel() {
        titleLabel.layer.borderColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).cgColor
        titleLabel.layer.borderWidth = 2
        titleLabel.layer.backgroundColor = UIColor.label.cgColor

    }
    private func Layout() {
        addSubview(titleLabel)
        addSubview(currentValueLabel)
        addSubview(editButton)
        addSubview(textField)
        
        titleLabel.DNLayoutConstraint(left: leftAnchor, right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40), size: CGSize(width: 0, height: 40))
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: -20).isActive = true
        
        currentValueLabel.DNLayoutConstraint(titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, margins: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12))
        
        editButton.DNLayoutConstraint(left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20), size: CGSize(width: 0, height: 44))
        
        textField.DNLayoutConstraint(right: leftAnchor, bottom: bottomAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 20), size: CGSize(width: 0, height: 44))
    }
    
    func toggle() {
        
    }

}
