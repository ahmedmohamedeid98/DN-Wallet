//
//  MyContactCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class MyContactCell: UITableViewCell {

    var contactImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.DN.DarkBlue.color()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var contactUsername: UILabel = {
        let lb = UILabel()
        lb.text = "Contact 1"
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 16)
        return lb
    }()
    
    var contactEmail: UILabel = {
        let lb = UILabel()
        lb.text = "Contact1@gmail.com"
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    
    var editContact : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.tintColor = UIColor.DN.DarkBlue.color()
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        return btn
    }()
    
    var deleteContact : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.tintColor = UIColor.DN.DarkBlue.color()
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        return btn
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let Vstack = UIStackView(arrangedSubviews: [contactUsername, contactEmail])
        let Hstack = UIStackView(arrangedSubviews: [editContact, deleteContact])
        Vstack.configureHstack()
        Hstack.configureVstack()
        
        addSubview(contactImage)
        addSubview(Vstack)
        addSubview(Hstack)
        
        contactImage.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 50, height: 50), centerV: true)
        Vstack.DNLayoutConstraint(topAnchor, left: contactImage.rightAnchor, right: Hstack.leftAnchor, bottom: bottomAnchor, margins: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8))
        Hstack.DNLayoutConstraint(right: rightAnchor ,size: CGSize(width: 70, height: 30), centerV: true)
    }
    
}

