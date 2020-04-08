//
//  SettingSection.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
    var id: Int { get }
}

enum SettingSection: Int, CaseIterable, CustomStringConvertible {
    case General
    case Security
    
    
    var description: String {
        switch self {
        case .General: return "General"
        case .Security: return "Security"
        }
    }
}

enum GeneralOptions: Int, CaseIterable, SectionType {
    case editProfile
    case privacy
    case language
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .editProfile: return "Eidt Profile"
        case .privacy: return "Privacy"
        case .language: return "Language"
        }
    }
    var id: Int {
        return self.rawValue
    }
    
    var indexPath: IndexPath {
        return IndexPath(row: self.rawValue, section: SettingSection.General.rawValue)
    }
}

enum SecurityOptions: Int, CaseIterable, SectionType {
    case safeMode
    case safeModeTime
    case enableLoginWithFaceID
    case password
    case hair
    
    
    
    var containsSwitch: Bool {
        switch self {
        case .safeMode: return true
        case .enableLoginWithFaceID: return true
        case .password: return false
        case .hair: return false
        case .safeModeTime: return false
        }
    }
    
    var description: String {
        switch self {
        case .safeMode: return "Enable safe mode"
        case .enableLoginWithFaceID: return "Enable login with Touch/Face ID"
        case .password: return "Change password"
        case .hair: return "Add hier"
        case .safeModeTime: return "Set safe mode time"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
    
    var indexPath: IndexPath {
        return IndexPath(row: self.rawValue, section: SettingSection.Security.rawValue)
    }
}
