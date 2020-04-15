//
//  HeaderCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/15/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionReusableView {
    
    var headerTitleLabel: UILabel = {
        let lb = UILabel()
        lb.basicConfigure()
        return lb
    }()
    
    var data: String? {
        didSet {
            headerTitleLabel.text = data ?? "test"
        }
    }
    
    func setupLayout() {
        addSubview(headerTitleLabel)
        headerTitleLabel.DNLayoutConstraintFill(top: 2, left: 10, right: 2, bottom: 2, withSafeArea: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
