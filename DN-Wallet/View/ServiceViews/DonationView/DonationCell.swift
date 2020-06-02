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
    var id: String = ""
    var data: Charity? {
        didSet {
            guard let safeData = data else {return}
            self.mail.text = safeData.email
            self.title.text = safeData.name
            self.id = safeData.id
            DNData.loadImageWithStrURL(str: safeData.link) { (img, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.logo.image = img
                    }
                }
            }
        }
    }

    var logo: UIImageView = {
        let img = UIImageView()
        img.tintColor = .DnColor
        img.image = UIImage(systemName: "photo.fill")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    private var title: UILabel = {
        let lb = UILabel()
        lb.text = "Organization Name"
        lb.textColor = .DnColor
        lb.font = UIFont.DN.Regular.font(size: 16)
        return lb
    }()
    
    private var mail: UILabel = {
        let lb = UILabel()
        lb.text = "orgnaization@gmail.com"
        lb.textColor = .DnColor
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
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

