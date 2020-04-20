//
//  HeaderCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/15/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    static let reuseIdentifier = "collection-view-header"
    
    var headerTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .DnDarkBlue
        lb.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return lb
    }()
    
    var data: String? {
        didSet {
            headerTitleLabel.text = data ?? "no data"
        }
    }
    
    func setupLayout() {
        addSubview(headerTitleLabel)
        headerTitleLabel.DNLayoutConstraintFill(top: 0, left: 8, right: 0, bottom: 0, withSafeArea: false)
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
