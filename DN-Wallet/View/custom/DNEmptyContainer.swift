//
//  DNEmptyContainer.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNEmptyContainer: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(borderWidth: CGFloat, borderColor: UIColor, backgroundColor: UIColor, cornerRedii: CGFloat = 0.0) {
        super.init(frame: .zero)
        self.layer.borderWidth       = borderWidth
        self.layer.borderColor       = borderColor.cgColor
        self.layer.cornerRadius      = cornerRedii
        self.backgroundColor         = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.borderWidth       = 1
        self.layer.borderColor       = UIColor.systemGray4.cgColor
        self.layer.cornerRadius      = 4
        self.backgroundColor         = .DnCellColor
    }
}
