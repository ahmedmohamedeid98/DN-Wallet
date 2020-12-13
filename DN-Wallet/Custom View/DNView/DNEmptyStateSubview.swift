//
//  DNEmptyStateSubview.swift
//  DN-Wallet
//
//  Created by Mac OS on 8/14/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNEmptyStateSubview: UIView {
    
    var messageLabel    = DNTitleLabel(textAlignment: .center, fontSize: 20)
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
        self.backgroundColor = .secondarySystemBackground
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
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 150),
            
            emptyStateImage.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImage.heightAnchor.constraint(equalToConstant: 80),
            emptyStateImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            emptyStateImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
    
}
