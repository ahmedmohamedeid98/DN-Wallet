
//
//  SideMenuCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/22/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    var serviceId : Int = 0
    var isSafe: Bool = false
    var serviceIcon : UIImageView = {
        let img = UIImageView()
        img.tintColor = UIColor.DN.DarkBlue.color()
        return img
    }()
    var serviceTitle: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.DN.DarkBlue.color()
        title.font = UIFont.DN.Regular.font(size: 16)
        return title
    }()
    var safeIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "lock.circle")
        img.tintColor = .green
        return img
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        self.safeIcon.isHidden = !isSafe
    }
    
    func setupLayout() {
        addSubview(serviceIcon)
        addSubview(serviceTitle)
        addSubview(safeIcon)
        serviceIcon.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 30, height: 30), centerV: true)
        serviceTitle.DNLayoutConstraint(left: serviceIcon.rightAnchor, right: safeIcon.leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), centerV: true)
        safeIcon.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8), size: CGSize(width: 20, height: 20), centerV: true)
    }
    
    func configure(id: Int, icon: String, title: String, sys: Bool = false) {
        self.serviceId = id
        self.serviceTitle.text = title
        if sys {
            self.serviceIcon.image = UIImage(systemName: icon)
        } else {
            self.serviceIcon.image = UIImage(named: icon)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
