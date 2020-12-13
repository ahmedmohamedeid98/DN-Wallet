//
//  DNEmptyStateView.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNEmptyStateView: UIView {
    
    var messageLabel    = DNTitleLabel(textAlignment: .center, fontSize: 28)
    var emptyStateImage = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    
    deinit {
        print("DNEmptyStateView was deallocated!!!!")
    }
    
    
    
    private func configure() {
        addSubview(messageLabel)
        addSubview(emptyStateImage)
        
        messageLabel.numberOfLines  = 3
        messageLabel.textColor      = .secondaryLabel
        
        emptyStateImage.image       = UIImage(named: "empty-state-logo")
        emptyStateImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            emptyStateImage.widthAnchor.constraint(equalToConstant: 200),
            emptyStateImage.heightAnchor.constraint(equalToConstant: 200),
            emptyStateImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 60),
            emptyStateImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }
}
