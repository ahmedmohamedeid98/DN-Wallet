//
//  DNNavBar.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/13/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNNavBar: UIView {
    
    var title: UILabel = {
        let title = UILabel()
        title.font = navBARTitleFont
        title.textColor = navBARTitleColor
        return title
    }()
    
    private(set) var leftBtn: UIButton = UIButton(type: .system)
    private(set) var rightBtn: UIButton = UIButton(type: .system)
    
    func addLeftItem(title: String? = nil, imageName: String, systemImage: Bool = true){

        if title != nil {
            leftBtn.setTitle(title!, for: .normal)
        }
        
        if systemImage {
            self.leftBtn.setImage(UIImage(systemName: imageName) , for: .normal)
            self.leftBtn.tintColor = .white
        } else {
            self.leftBtn.setImage(UIImage(named: imageName), for: .normal)
        }
            
        addSubview(leftBtn)
        leftBtn.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        leftBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
    }
    
    func addRightItem(title: String? = nil, imageName: String, systemImage: Bool = true) {
        
        if title != nil {
            leftBtn.setTitle(title!, for: .normal)
        }
        
        if systemImage {
            self.rightBtn.setImage(UIImage(systemName: imageName), for: .normal)
            self.rightBtn.tintColor = .white
        } else {
            self.rightBtn.setImage(UIImage(named: imageName), for: .normal)
        }
        
        addSubview(rightBtn)
        rightBtn.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 30, height: 30))
        rightBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        
    }
    
    
    fileprivate func setupLayout() {
        addSubview(title)
        title.DNLayoutConstraint(centerH: true)
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = navBARColor
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
