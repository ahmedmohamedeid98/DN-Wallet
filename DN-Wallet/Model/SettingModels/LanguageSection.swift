//
//  LanguageSection.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

enum LanguageSection: Int, CaseIterable, CustomStringConvertible {
    case English
    case Arabic

    var description: String {
        switch self {
        case .English: return "English"
        case .Arabic: return "العربية"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}
