//
//  VerifyManager.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol VerifyManagerProtocol {
    func sendPhoneVerifiCode(toPhone phone: String, completion: @escaping(Result<Bool, NSError>) -> ())
    func sendEmailVerifiCode(toEmail email: String, completion: @escaping(Result<Bool, NSError>) -> ())
    func verifyPhone(withCode code: String, andPhone phone: String, completion: @escaping(Result<Bool, NSError>) -> ())
    func verifyEmail(withCode code: String, email: String, andDate date: String, completion: @escaping(Result<Bool, NSError>) -> ())
}

class VerifyManager: BaseAPI<VerifyNetworking>, VerifyManagerProtocol {
    
    func sendPhoneVerifiCode(toPhone phone: String, completion: @escaping(Result<Bool, NSError>) -> ()) {
    
    }
    
    func sendEmailVerifiCode(toEmail email: String, completion: @escaping(Result<Bool, NSError>) -> ()) {
    
    }
    
    func verifyPhone(withCode code: String, andPhone phone: String, completion: @escaping(Result<Bool, NSError>) -> ()) {
    
    }
    
    func verifyEmail(withCode code: String, email: String, andDate date: String, completion: @escaping(Result<Bool, NSError>) -> ()) {
    
    }
    
}
