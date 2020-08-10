//
//  TransactionManager.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

//protocol TransferManagerProtocol {
//    func getUserBalace(completion: @escaping(Result<Balance, NSError>) -> () )
//    func getPaymentCards(completion: @escaping(Result<GetPaymentCards, NSError>) -> () )
//    func addPaymentCard(withData: PostPaymentCard, completion: @escaping(Result<PostPaymentCard, NSError>) -> () )
//    func chargeAccount(withData: Transfer, id: String, completion: @escaping(Result<Transfer, NSError>) -> ())
//    func withdrawAccount(withData: Transfer, id: String, completion: @escaping(Result<Transfer, NSError>) -> ())
//    func transfer(withData: Transfer, email: String, completion: @escaping(Result<Transfer, NSError>) -> ())
//    func donate(withData: Transfer, id: String, completion: @escaping(Result<Transfer, NSError>) -> ())
//}

class TransferManager: BaseAPI<TransferNetworking> {
    
    static let shared = TransferManager()
    private override init() {}
    
    func getUserBalace(completion: @escaping (Result<[Balance], NSError>) -> ()) {
        APIRequest(target: .getUserBalance, responseClass: [Balance].self, completion: completion)
    }
    
    func getPaymentCards(completion: @escaping (Result<[GetPaymentCards], NSError>) -> ()) {
        APIRequest(target: .getUserPaymentCards, responseClass: [GetPaymentCards].self, completion: completion)
    }
    
    func addPaymentCard(withData: PostPaymentCard, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        APIRequest(target: .postPaymentCard(withData), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func chargeAccount(withData: Transfer, id: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        APIRequest(target: .charge(withData, id), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func withdrawAccount(withData: Transfer, id: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        APIRequest(target: .withdraw(withData, id), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func donate(withData: Transfer, id: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        APIRequest(target: .donate(withData, id), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func transfer(withData: Transfer, email: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        APIRequest(target: .transfer(withData, email), responseClass: SuccessResponse.self, completion: completion)
    }
    
    
    
}
