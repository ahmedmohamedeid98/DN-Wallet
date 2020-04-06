//
//  EditProfileSection.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

enum EditProfileSection: Int, CaseIterable, CustomStringConvertible {
    case image
    case username
    case address
    case phone
    
    var description: String {
        switch self {
        case .image: return "Image"
        case .username: return "Username"
        case .address: return "Address"
        case .phone: return "Phone"
        }
    }
}
