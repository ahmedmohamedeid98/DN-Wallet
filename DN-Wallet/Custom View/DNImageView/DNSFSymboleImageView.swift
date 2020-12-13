//
//  DNSFSymboleImageView.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNSFSymboleImageView: UIImageView {

    init(sfSymbol: SFSymobol, tintColor tColor: UIColor = .secondaryLabel) {
        super.init(frame: .zero)
        image       = UIImage(systemName: sfSymbol.rawValue)
        tintColor   = tColor
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentMode = .scaleAspectFit
    }
    
}
