//
//  TransactionNetworking.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum TransferNetworking {
    case getUserBalance
    case getUserPaymentCards
    case postPaymentCard(PostPaymentCard)
    case charge(Transfer, String)
    case withdraw(Transfer, String)
    case transfer(Transfer, String)
    case donate(Transfer, String)
    case exchange(String, String, Int)
}

extension TransferNetworking: TargetType {
    
    var baseURL: String {
        return "https://dn-wallet.herokuapp.com/api"
    }
    
    var path: String {
        switch self {
            case .getUserBalance:       return "/cards/balance/"
            case .getUserPaymentCards:  return "/cards"
            case .postPaymentCard:      return "/cards/create"
            case .charge(_, let id):    return "/cards/charge/\(id)"
            case .withdraw(_, let id):  return "/cards/withdraw/\(id)"
            case .transfer:             return "/cards/transfer"
            case .donate(_, let id):    return "/charity/donate/\(id)"
            case .exchange:             return "/cards/exchange"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getUserBalance:       return .get
            case .getUserPaymentCards:  return .get
            case .postPaymentCard:      return .post
            case .charge:               return .post
            case .withdraw:             return .post
            case .transfer:             return .post
            case .donate:               return .post
            case .exchange:             return .post
        }
    }
    
    var task: Task {
        switch self {
            case .getUserBalance:
                return .requestPlain
            
            case .getUserPaymentCards:
                return .requestPlain
            
            case .postPaymentCard(let card):
                return .requestParameters([
                    "cardNumber": card.cardNumber,
                    "cardType": card.cardType,
                    "cvc": card.cvc,
                    "expMonth": card.expMonth,
                    "expYear": card.expYear
                ])
            
            case .charge(let data, _):
                return .requestParameters([
                    "amount": data.amount,
                    "currency_code": data.currency_code
                ])
            
            case .withdraw(let data, _):
                return .requestParameters([
                    "amount": data.amount,
                    "currency_code": data.currency_code
                ])
            case .transfer(let data, let email):
                return .requestParameters([
                    "amount": data.amount,
                    "currency_code": data.currency_code,
                    "email": email
                ])
            case .donate(let data, _):
                return .requestParameters([
                    "amount": data.amount,
                    "currency_code": data.currency_code
                ])
            case .exchange(let curr_from,let curr_to,let amount):
                return .requestParameters(["curr_from": curr_from , "curr_to": curr_to, "amount": amount])
        }
    }
    
    var header: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var tokenRequired: Bool {
        return true
    }
}

