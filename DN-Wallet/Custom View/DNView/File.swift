//
//  File.swift
//  DN-Wallet
//
//  Created by Mac OS on 8/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

class DNWordAlert: UIView {
    
    var message: String!
    var messageLabel = DNSecondaryTitleLabel(fontSize: 18)
    
    init(message: String) {
        super.init(frame: .zero)
        self.message = message
        configureLabel()
        Layout()
    }
    
    private func configureLabel() {
        messageLabel.textColor = #colorLiteral(red: 0.2274509804, green: 0.6862745098, blue: 0.2666666667, alpha: 1)
    }
    
    private func Layout() {
        addSubview(messageLabel)
        messageLabel.DNLayoutConstraintFill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
