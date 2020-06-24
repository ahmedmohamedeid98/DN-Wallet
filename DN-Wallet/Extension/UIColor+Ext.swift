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
        return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
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
    
    class func randomColor(forChar char: Character) -> UIColor {
        let u_char = char.lowercased()
        switch u_char {
        case "a": return #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
        case "b": return #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        case "c": return #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case "d": return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case "e": return #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        case "f": return #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        case "g": return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        case "h": return #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
        case "i": return #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
        case "j": return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        case "k": return #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
        case "l": return #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        case "m": return #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        case "n": return #colorLiteral(red: 0.2549019608, green: 0.6117647059, blue: 1, alpha: 1)
        case "o": return #colorLiteral(red: 0.6352941176, green: 0.6352941176, blue: 0.6549019608, alpha: 1)
        case "p": return #colorLiteral(red: 0.3882352941, green: 0.3803921569, blue: 0.9490196078, alpha: 1)
        case "q": return #colorLiteral(red: 0.431372549, green: 0.862745098, blue: 1, alpha: 1)
        case "r": return #colorLiteral(red: 0.8, green: 0.3960784314, blue: 1, alpha: 1)
        case "s": return #colorLiteral(red: 1, green: 0.2549019608, blue: 0.4117647059, alpha: 1)
        case "t": return #colorLiteral(red: 0.7137254902, green: 0.5960784314, blue: 0.4470588235, alpha: 1)
        case "u": return #colorLiteral(red: 1, green: 0.8784313725, blue: 0.07843137255, alpha: 1)
        case "v": return #colorLiteral(red: 1, green: 0.662745098, blue: 0.07843137255, alpha: 1)
        case "w": return #colorLiteral(red: 0.07843137255, green: 0.5568627451, blue: 1, alpha: 1)
        case "x": return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case "y": return #colorLiteral(red: 1, green: 0.3098039216, blue: 0.2666666667, alpha: 1)
        default:
            return #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        }
    }
    
}
