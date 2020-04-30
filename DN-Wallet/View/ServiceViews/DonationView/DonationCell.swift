//
//  MyContactCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit


class DonationCell: UITableViewCell {

    static let reuseIdentifier: String = "donation-cell-identifier"
    
    
    
    var org_mail: String? {
        didSet {
            guard let email = org_mail else { return }
            self.mail.text = email
        }
    }
    
    var org_title: String? {
        didSet {
            guard let _title = org_title else { return }
            self.title.text = _title
        }
    }
    
    var logo: UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.DN.DarkBlue.color()
        img.image = UIImage(systemName: "photo.fill")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    private var title: UILabel = {
        let lb = UILabel()
        lb.text = "Organization Name"
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 16)
        return lb
    }()
    
    private var mail: UILabel = {
        let lb = UILabel()
        lb.text = "orgnaization@gmail.com"
        lb.textColor = UIColor.DN.DarkBlue.color()
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let Vstack = UIStackView(arrangedSubviews: [title, mail])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 8)
        
        addSubview(logo)
        addSubview(Vstack)
        
        logo.DNLayoutConstraint(left: contentView.leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 50, height: 50), centerV: true)
        Vstack.DNLayoutConstraint(contentView.topAnchor, left: logo.rightAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, margins: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8))
    }
    
}

