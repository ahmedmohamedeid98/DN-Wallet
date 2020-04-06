//
//  UserQuikDetails.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class UserQuikDetails: UIView {
    
    let userImage: UIImageView = {
        let uImage = UIImageView()
        uImage.layer.cornerRadius = 20
        uImage.image = UIImage(systemName: "person.circle")
        uImage.backgroundColor = .orange
        uImage.tintColor = .white
        uImage.clipsToBounds = true
        uImage.contentMode = .scaleAspectFit
        return uImage
    }()
    
    let userName: UILabel = {
        let lb = UILabel()
        lb.text = "username"
        lb.textColor = UIColor.DN.Black.color()
        lb.font = UIFont.DN.Bold.font(size: 16)
        return lb
    }()
    
    let userEmail: UILabel = {
        let lb = UILabel()
        lb.text = "user@example.com"
        lb.textColor = .lightGray
        lb.font = UIFont.DN.Regular.font(size: 12)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(userImage)
        userImage.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 40, height: 40), centerV: true)
        
        let stackView = UIStackView(arrangedSubviews: [userName, userEmail])
        stackView.configureHstack()
        addSubview(stackView)
        stackView.DNLayoutConstraint(left: userImage.rightAnchor, right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 20), size: CGSize(width: 0, height: 40))
        stackView.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
