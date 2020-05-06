//
//  UserDefaultKeys.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

enum Defaults : String {
    case Language
    case Currency
    case FirstLaunch
    case LoginWithBiometric
    case EnableSafeMode
    case BiometricTypeFaceID
    case BiometricTypeTouchID
    
    var key: String {
        return self.rawValue
    }
}
