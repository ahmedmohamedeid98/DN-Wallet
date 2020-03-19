//
//  MyContactCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DonationCell: UITableViewCell {

    var orgImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.DN.DarkBlue.color()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var orgName: UILabel = {
        let lb = UILabel()
        lb.text = "Organization Name"
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 16)
        return lb
    }()
    
    var orgEmail: UILabel = {
        let lb = UILabel()
        lb.text = "orgnaization@gmail.com"
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    
    var donateButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.titleLabel?.font = UIFont.DN.Regular.font(size: 12)
        btn.setTitle("Donate", for: .normal)
        btn.backgroundColor = UIColor.DN.DarkBlue.color()
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    var detailsButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = UIColor.DN.DarkBlue.color()
        btn.setImage(UIImage(systemName: "exclamationmark.circle.fill"), for: .normal)
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
        let Vstack = UIStackView(arrangedSubviews: [orgName, orgEmail])
        Vstack.configureHstack()
        
        addSubview(orgImage)
        addSubview(Vstack)
        addSubview(donateButton)
        addSubview(detailsButton)
        
        orgImage.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 50, height: 50), centerV: true)
        Vstack.DNLayoutConstraint(topAnchor, left: orgImage.rightAnchor, right: donateButton.leftAnchor, bottom: bottomAnchor, margins: UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8))
        detailsButton.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 30, height: 25), centerV: true)
        donateButton.DNLayoutConstraint(right: detailsButton.leftAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2),size: CGSize(width: 50, height: 25), centerV: true)
    }
    
}

