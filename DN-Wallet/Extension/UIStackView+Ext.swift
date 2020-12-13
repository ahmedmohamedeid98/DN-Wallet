//
//  UIStackView+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension UIStackView {
    func configureStack(axis: NSLayoutConstraint.Axis , distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, space: CGFloat) {
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = space
    }
}
