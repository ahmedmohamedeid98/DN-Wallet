//
//  UserQuikDetails.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class UserQuikDetails: UIView {
    
    //MARK:- Properities
    let userImage   = DNImageView(title: "person.circle", isSystemImage: true)
    let userName    = DNTitleLabel(title: "username", alignment: .left, fontSize: 16, weight: .bold)
    let userEmail   = DNTitleLabel(title: "user@example.com", alignment: .left, fontSize: 12)
    
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .DnCellColor
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK:- configure
    private func configureSubviews() {
        addSubview(userImage)
        userImage.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 40, height: 40), centerV: true)
        userImage.roundImageWithHeight = 40
        
        let stackView = UIStackView(arrangedSubviews: [userName, userEmail])
        stackView.configureHstack()
        addSubview(stackView)
        stackView.DNLayoutConstraint(left: userImage.rightAnchor, right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20), size: CGSize(width: 0, height: 40))
        stackView.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
    }
}
