//
//  UserDefaultKeys.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

enum Defaults : String {
    case Language
    case FirstLaunch
    case LoginWithBiometric
    case EnableSafeMode
    
    var key: String {
        return self.rawValue
    }
}
