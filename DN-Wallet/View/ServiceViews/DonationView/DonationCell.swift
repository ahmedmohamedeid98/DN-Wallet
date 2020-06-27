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
    private var logo    = DNImageView(title: "photo.fill", tintColor: .DnColor, contentMode: .scaleAspectFit, isSystemImage: true)
    private var title   = DNTitleLabel(title: "org name", alignment: .left, fontSize: 16, weight: .regular)
    private var mail    = DNTitleLabel(title: "org@example.com", alignment: .left, fontSize: 14, weight: .regular)
   
    var data: Charity? {
        didSet {
            guard let safeData = data else {return}
            self.mail.text = safeData.email
            self.title.text = safeData.name
            NetworkManager.loadImageWithStrURL(str: safeData.org_logo) { result in
                switch result {
                    case .success(let img):
                        DispatchQueue.main.async {
                           self.logo.image = img
                        }
                        
                    case .failure(_):
                        break
                }
            }
        }
    }

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .DnCellColor
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

