//
//  PrivacyCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PrivacyCell: UITableViewCell {
    
    var textView: UITextView = DNTextView(text: " ", alignment: .left, fontSize: 14)
       
    func configureCell(text: String?) {
        self.textView.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(textView)
        textView.DNLayoutConstraintFill(top: 8, left: 8, right: 8, bottom: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
