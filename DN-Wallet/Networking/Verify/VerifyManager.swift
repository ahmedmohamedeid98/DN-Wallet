//
//  VerifyManager.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol VerifyManagerProtocol {
    func sendPhoneVerifiCode(toPhone phone: String, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func sendEmailVerifiCode(completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func verifyPhone(withCode code: String, andPhone phone: String, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func verifyEmail(withCode code: String, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func checkAcountActiveStatus(completion: @escaping (Result<AccountIsActive, NSError>) -> ())
}

class VerifyManager: BaseAPI<VerifyNetworking>, VerifyManagerProtocol {
    
    func sendPhoneVerifiCode(toPhone phone: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .sendPhoneVerifiCode(toPhone: phone), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func sendEmailVerifiCode(completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .sendEmailVerifiCode, responseClass: SuccessResponse.self, completion: completion)
    }
    
    func verifyPhone(withCode code: String, andPhone phone: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .verifyPhone(withCode: code, andNumber: phone), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func verifyEmail(withCode code: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .verifyEmail(withCode: code), responseClass: SuccessResponse.self, completion: completion)
    }
    
    // this method should return accountIsActive = true if account is active otherwise false
    func checkAcountActiveStatus(completion: @escaping (Result<AccountIsActive, NSError>) -> ()) {
        self.APIRequest(target: .accountIsActive, responseClass: AccountIsActive.self, completion: completion)
    }
}
