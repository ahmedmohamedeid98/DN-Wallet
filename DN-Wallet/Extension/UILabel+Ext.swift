//
//  UILabel+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension UILabel {
    func basicConfigure(fontSize: CGFloat = 16) {
        self.font = UIFont.DN.Regular.font(size: fontSize)
        self.textColor = .DnDarkBlue
    }
}
