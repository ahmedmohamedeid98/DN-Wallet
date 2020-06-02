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

class SAUserDefaults {
    static let languageKay = "Language"
    static let currencyKay = "currency-key"
    static let FirstLanchKay = "firstLanch-key"
    
    class func getBoolValue(withKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
//    class func setBoolValue(withKey key: String) {
//        UserDefaults.standard.set(true, forKey: key)
//    }
    
    class func getStringValue(withKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    class func getIntValue(withKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
//    class func setStringValue(_ value: String, withKey key: String) {
//        UserDefaults.standard.set(value, forKey: key)
//    }
    
    class func setValue<T: Any>(_ value: T, withKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
