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
        textColor = .DnColor
    }
    
    
    init(title: String, textColor:UIColor = .DnColor ,alignment: NSTextAlignment, fontSize: CGFloat = 0.0, weight: UIFont.Weight = .regular) {
        super.init(frame: .zero)
        self.text            = title
        self.textAlignment   = alignment
        self.textColor       = textColor
        configure()
        if fontSize > 0 { font = UIFont.systemFont(ofSize: fontSize, weight: weight) }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font        = UIFont.preferredFont(forTextStyle: .title3)
    }
}
