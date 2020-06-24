//
//  DNTitleLabel.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    init(title: String, alignment: NSTextAlignment) {
        super.init(frame: .zero)
        text            = title
        textAlignment   = alignment
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font        = UIFont.preferredFont(forTextStyle: .title3)
        textColor   = .DnColor
    }
}
