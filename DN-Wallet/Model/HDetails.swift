//
//  HDetails.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/16/20.
//  Copyright © 2020 DN. All rights reserved.
//



/// Enumeration conatain the details data for the three history category
enum HDetails{
    
    case consumption
    case received
    case donations
    
    
    /// enum method return nav bar title for each one of the three history category
    func title() -> String {
        
        switch self {
            case .consumption:
                return "CONSUMPTIONS"
            case .received:
                return "RECIVED"
            case .donations:
                return "DONATIONS"
        }
    }
    
    /// enum method return segment controller items for each one of the three history catefory
    func segItems() -> [String] {
        
        switch self{
            case .consumption:
                return ["Purchases", "Individuals"]
            case .received:
                return ["Sales", "Individuals"]
            case .donations:
                return []
        }
    }
    
    /// enum method return boolean value which determine if the view controller conatina a uisegment controller or not
    func withSeg() -> Bool {
        switch self {
            case .consumption:
                return false
            case .received:
                return false
            case .donations:
                return true
        }
        
    }
    
    /// enum method return the info label text for each one of the three history catefory
    func infoLabel() -> String {
        switch self {
            
        case .consumption:
            return "You was sent money to"
        case .received:
            return "You was received money from"
        case .donations:
            return "You was donation to"
        }
    }
    
}
