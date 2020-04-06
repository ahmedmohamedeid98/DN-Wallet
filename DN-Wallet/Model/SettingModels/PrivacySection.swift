//
//  PrivacySection.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/6/20.
//  Copyright © 2020 DN. All rights reserved.
//
import UIKit

enum PrivacySection: Int, CaseIterable, CustomStringConvertible {
    case Camera
    case BiometricAuth
    case Location
    
    var title: String {
        switch self {
        case .Camera: return "Camera"
        case .BiometricAuth: return "Login With Touch/Face ID"
        case .Location: return "Location"
        }
    }
    
    var description: String {
        switch self {
            
        case .Camera:
            return "Nullam porta cursus lobortis. Donec consectetur lorem metus, ac rhoncus sapien sagittis congue. Ut sed justo hendrerit, maximus nibh sed, dictum mauris. Praesent ac quam volutpat, ullamcorper ipsum vitae, cursus dui. Proin euismod elementum arcu quis interdum. Donec euismod rhoncus magna et sollicitudin. Nunc nisl augue"
        case .BiometricAuth:
            return "interdum id porta nec, ullamcorper eu nulla. Vivamus aliquet faucibus odio, quis tristique risus varius eu. Donec tincidunt nibh sit amet elit gravida, at condimentum metus gravida. Donec sed venenatis felis, nec congue felis.Praesent ac quam volutpat, ullamcorper ipsum vitae, cursus dui. Proin euismod elementum arcu quis interdum. Donec euismod rhoncus magna et sollicitudin. Nunc nisl augue, interdum id porta nec, ullamcorper eu nulla. Vivamus aliquet faucibus odio, quis tristique risus varius eu. Donec tincidunt nibh sit amet elit gravida, at condimentum metus gravida. Donec sed venenatis felis, nec congue felis.Praesent ac quam volutpat, ullamcorper ipsum vitae, cursus dui. Proin euismod elementum arcu quis interdum. Donec euismod rhoncus magna et sollicitudin. Nunc nisl augue, interdum id porta nec, ullamcorper eu nulla. Vivamus aliquet faucibus odio, quis tristique risus varius eu. Donec tincidunt nibh sit amet elit gravida, at condimentum metus gravida. Donec sed venenatis felis, nec congue felis."
        case .Location:
            return "Praesent ac quam volutpat, ullamcorper ipsum vitae, cursus dui. Proin euismod elementum arcu quis interdum. Donec euismod rhoncus magna et sollicitudin. Nunc nisl augue, interdum id porta nec, ullamcorper eu nulla. Vivamus aliquet faucibus odio, quis tristique risus varius eu. Donec tincidunt nibh sit amet elit gravida, at condimentum metus gravida. Donec sed venenatis felis, nec congue felis."
        }
    }
    
    var height: CGFloat {
        let width = UIScreen.main.bounds.width - 20
        let font = UIFont.DN.Regular.font(size: 14)
        return self.description.heightWithConstrainedWidth(width: width, font: font)
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
