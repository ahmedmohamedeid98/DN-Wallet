//
//  UserPreference.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/21/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

class UserPreference {
    // keys
    static let languageKay = "LanguageKey"
    static let currencyKay = "currencyKey"
    static let firstLanchKay = "firstLanchkey"
    static let loginWithBiometric = "loginWithBiometric"
    static let enableSafeMode = "enableSafeMod"
    static let biometricTypeFaceID = "biometricTypeFaceID"
    static let biometricTypeTouchID = "biometricTypeTouchID"
    static let country = "country-key"
    static let phone = "phone-key"
    
    // get
    class func getBoolValue(withKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func getStringValue(withKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    class func getIntValue(withKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    // set
    class func setValue<T: Any>(_ value: T, withKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    
}
