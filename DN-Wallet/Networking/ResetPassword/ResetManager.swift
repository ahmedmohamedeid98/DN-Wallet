//
//  ResetManager.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol ResetManagerProtocol {
    func forgetPassword(forEmail email: String, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func forgetPasswordCheck(email: String, code: String, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func resetPassword(newPassword: String, code: String, email: String, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func updatePassword(oldPassword : String, newPassword: String, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
}

class ResetManager: BaseAPI<ResetNetworking>, ResetManagerProtocol {
    
    func forgetPassword(forEmail email: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .forgetPassword(forEmail: email), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func forgetPasswordCheck(email: String, code: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .forgetPasswordCheck(email: email, code: code), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func resetPassword(newPassword: String, code: String, email: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .resetPassword(newPassword: newPassword, code: code, email: email), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func updatePassword(oldPassword: String, newPassword: String, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .updatePassword(oldPassword: oldPassword, newPassword: newPassword), responseClass: SuccessResponse.self, completion: completion)
    }
}
