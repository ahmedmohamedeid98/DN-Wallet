//
//  UIColor+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension UIColor {
    
    static var DnGrayColor: UIColor {
        return .systemGray2
    }
    static var DnWhiteColor: UIColor {
        return .white
    }
    static var DnColor: UIColor {
        return #colorLiteral(red: 0.1782214642, green: 0.4982336164, blue: 0.757638514, alpha: 1)
    }
    static var DnVcBackgroundColor: UIColor {
        return UIColor(named: "Dynamic-Background") ?? UIColor.gray
    }
    static var DnCellColor: UIColor {
        return UIColor(named: "Dynamic-Cell") ?? UIColor.gray
    }
    
    static var DnTextColor: UIColor {
        return .label
    }
    static var DnDarkBlue: UIColor {
        return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    static var DnBackgroundColor: UIColor {
        return .systemGroupedBackground
    }
    static var DnBorderColor: UIColor {
        return #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
    }
}
