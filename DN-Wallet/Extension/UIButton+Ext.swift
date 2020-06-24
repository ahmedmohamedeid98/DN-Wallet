//
//  extension.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

extension UIButton {
    func enable() {
        self.isHighlighted = false
        self.isEnabled = true
    }
    func disable() {
        self.isHighlighted = true
        self.isEnabled = false
    }
}
