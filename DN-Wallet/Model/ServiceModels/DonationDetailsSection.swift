//
//  DonationDetailsSections.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/30/20.
//  Copyright © 2020 DN. All rights reserved.
//

enum DonationDetailsSectoin: Int, CaseIterable, CustomStringConvertible {
    case Vision
    case Address
    case Founders
    case Concat
    case About
    
    var description: String {
        switch self {
        case .Vision: return "Vision"
        case .Address: return "Address"
        case .Founders: return "Founders"
        case .Concat: return "Concat"
        case .About: return "About"
        }
    }
    
}
struct charityLocation {
    let location: Location
    let title: String
    let subtitle: String
}
