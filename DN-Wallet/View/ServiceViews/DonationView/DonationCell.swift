//
//  MyContactCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit


class DonationCell: UITableViewCell {

    static let reuseIdentifier: String  = "donation-cell-identifier"
    private var logo                    = DNAvatarImageView(frame: .zero)
    private var title                   = DNTitleLabel(textAlignment: .left, fontSize: 16)
    private var mail                    = DNSecondaryTitleLabel(fontSize: 14)
    
   
    var data: Charity? {
        didSet {
            guard let safeData = data else {return}
            self.mail.text = safeData.email
            self.title.text = safeData.name
            self.logo.downlaodedImage(from: safeData.org_logo)
        }
    }

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor    = .DnCellColor
        accessoryType      = .disclosureIndicator
        setupLayout()
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

