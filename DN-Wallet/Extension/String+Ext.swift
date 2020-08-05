//
//  String+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/3/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// used usually to determine table view cell height
    func textHeight() -> CGFloat {
        let width = UIScreen.main.bounds.width - 40
        let font = UIFont.DN.Regular.font(size: 16)
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
