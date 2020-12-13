//
//  AccountInfo.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//


struct AccountInfo: Codable {
    let user: UserInfo
    //let balance : [Balance]
    //let payment_cards: [CardInfo]
}

struct Balance: Codable {
    let amount: String
    let currency_code: String
}

struct PostPaymentCard: Codable {
    let cardType: String
    let cardNumber: String
    let cvc: String
    let expYear: String
    let expMonth: String
}

struct GetPaymentCards: Codable, Hashable {
    let _id: String
    let cardID: CardInfo
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self._id)
    }
}
struct CardInfo: Codable, Hashable {
    let _id : String
    let cardType: String
    let last4Num: String
}
/*
 {
     "amount": 500,
     "currency_code" : "EGP"
 }
 **/

struct Transfer: Codable {
    let amount: String
    let currency_code: String
}



struct UserInfo: Codable {
    let gender: String?
    let phone: String?
    let job: String?
    let photo: String?
    let country: String?
    let userIsValidate: Bool
    let name: String
    let email: String
}

// Check if the user verfied his email after registeration process or not
struct AccountIsActive: Codable {
    let accountIsActive : Bool
}

struct BasicUserInfo {
    let name: String
    let email: String
    let photo: String?
}
