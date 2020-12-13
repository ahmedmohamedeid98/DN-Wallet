//
//  DNTextView.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DNTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    init(text: String, alignment: NSTextAlignment, fontSize: CGFloat, editable: Bool = false) {
        super.init(frame: .zero, textContainer: nil)
        self.text           = text
        self.textAlignment  = alignment
        self.font           = UIFont.systemFont(ofSize: fontSize)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textColor           = .secondaryLabel
        backgroundColor     = .clear
    }
}
