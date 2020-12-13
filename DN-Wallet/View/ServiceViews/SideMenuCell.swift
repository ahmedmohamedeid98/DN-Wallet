
//
//  SideMenuCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/22/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    static let reuseIdentifier = "side-menu-cell-identrifer"
    var inSafeMode: Bool = false
    var section: ServiceSection? {
        didSet {
            guard let data = section else {return}
            self.serviceTitle.text = data.description
            if data.sysImage {
                self.serviceIcon.image = UIImage(systemName: data.image)
            } else {
                self.serviceIcon.image = UIImage(named: data.image)
            }
            if inSafeMode {
                self.safeIcon.isHidden = !data.isSafe
            } else {
                self.safeIcon.isHidden = true
            }
        }
    }
    
    var serviceIcon : UIImageView = {
        let img = UIImageView()
        img.tintColor = .white//UIColor.DN.DarkBlue.color()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    var serviceTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white//UIColor.DN.DarkBlue.color()
        title.font = UIFont.DN.Regular.font(size: 16)
        return title
    }()
    var safeIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "lock.circle")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.tintColor = .white
        return img
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .clear
    }
    
    func setupLayout() {
        addSubview(serviceIcon)
        addSubview(serviceTitle)
        addSubview(safeIcon)
        serviceIcon.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 30, height: 30), centerV: true)
        serviceTitle.DNLayoutConstraint(left: serviceIcon.rightAnchor, right: safeIcon.leftAnchor, margins: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 4), centerV: true)
        safeIcon.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8), size: CGSize(width: 20, height: 20), centerV: true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
