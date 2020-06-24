//
//  DNTextField.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    init(placeholder: String, stopSmartActions: Bool = true, isSecure: Bool = false) {
        super.init(frame: .zero)
        self.placeholder        = placeholder
        self.isSecureTextEntry  = isSecure
        if stopSmartActions { self.stopSmartActions() }
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textColor                   = .label
        font                        = UIFont.preferredFont(forTextStyle: .callout)
        adjustsFontSizeToFitWidth   = true
        minimumFontSize             = 9.0
        backgroundColor             = .DnCellColor
    }
    
}
