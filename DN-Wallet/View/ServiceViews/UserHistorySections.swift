//
//  UserHistorySections.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol UserHistorySectionProtocol: CustomStringConvertible {
    var title: String { get }
    var category: UserHistoryCellColor { get }
    var action: UserHistoryCellDetailsAction { get }
    var segmentItems: [String] { get }
    var infoLabel: String { get }
    var withSegment: Bool { get }
    
}

enum UserHistorySections: Int, CaseIterable, UserHistorySectionProtocol {
    
    case consumptions
    case received
    case donation
    
    var title: String {
        switch self {
            case .consumptions: return "CONSUMPTIONS"
            case .received:     return "RECEIVED"
            case .donation:     return "DONATIONS"
        }
    }
    
    var description: String {
        switch self {
            case .consumptions: return "Consumption include the purchases and the money that you sent to others."
            case .received: return "Received include the sales and the money received from others."
            case .donation: return "Donations include the money that send to the charitable origanizations."
        }
    }
    
    var category: UserHistoryCellColor {
        switch self {
            case .consumptions: return .consumptionColor
            case .received:     return .recievedColor
            case .donation:     return .donationsColor
        }
    }
    
    var action: UserHistoryCellDetailsAction {
        switch self {
            case .consumptions: return .consumptionAction
            case .received:     return .recievedAction
            case .donation:     return .dontationAction
        }
    }
    
    var segmentItems: [String] {
        switch self {
            case .consumptions: return ["Purchases", "Individuals"]
            case .received:     return ["Sales", "Individuals"]
            case .donation:     return []
        }
    }
    
    var infoLabel: String {
        switch self {
            case .consumptions: return "You was sent money to"
            case .received:     return "You was received money from"
            case .donation:     return "You was donation to"
        }
    }
    
    var withSegment: Bool {
        switch self {
            case .consumptions: return true
            case .received:     return true
            case .donation:     return false
        }
    }
    
}
