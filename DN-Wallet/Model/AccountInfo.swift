//
//  AccountInfo.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct AccountInfo: Codable {
    let userIsValidate: Bool
    let name: String
    let email: String
    let country: String?
    let phone: String?
    let gender: String?
    let job: String?
    //let photo: String?
    //let balance : [Balance]
    //let payment_cards: [CardInfo]
}

struct Balance: Codable {
    let amount: Double
    let currency: String
    
    func stringAmount(amount: Double) -> String {
        return String(format: "%i.%02i", arguments: [Int(amount), amount*100.truncatingRemainder(dividingBy: 100)])
    }
}

struct CardInfo: Codable, Hashable {
    let id : String
    let name: String
    let type: String
    let digits: String
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.id)
    }
}

