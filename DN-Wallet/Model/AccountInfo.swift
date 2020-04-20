//
//  AccountInfo.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct AccountInfo: Codable {
    let username: String
    let email: String
    let country: String
    let phone: String
    let gender: String
    let job: String
    let photo: String
    let balance : [Balance]
    let paymentCards: [PaymentCards]
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case country
        case phone
        case gender
        case job
        case photo
        case balance
        case paymentCards = "payment_cards"
    }
}

struct Balance: Codable, Hashable {
    let amount: Double
    let currency: String
    let identifier: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency = "currency_code"
    }
    
    //confiram hashable protocol
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: Balance, rhs: Balance) -> Bool{
        return lhs.identifier == rhs.identifier
    }
}

struct PaymentCards: Codable {
    let id : String
    let name: String
    let type: String
    let digits: String
    
    enum CodingKeys: String, CodingKey {
        case id = "card_id"
        case name = "card_name"
        case type = "card_type"
        case digits = "last_4_digits"
    }
}

