//
//  ResetManager.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol RestManagerProtocol {
    func forgetPassword(forEmail email: String, completion: @escaping(Result<Bool, NSError>) -> ())
    func resetPassword(newPassword: String, code: String, email: String, completion: @escaping(Result<Bool, NSError>) -> ())
    func updatePassword(newPassword: String, completion: @escaping(Result<Bool, NSError>) -> ())
}

class ResetManager: BaseAPI<ResetNetworking>, RestManagerProtocol {
    
    func forgetPassword(forEmail email: String, completion: @escaping (Result<Bool, NSError>) -> ()) {
         // code
    }
    
    func resetPassword(newPassword: String, code: String, email: String, completion: @escaping (Result<Bool, NSError>) -> ()) {
        // code
    }
    
    func updatePassword(newPassword: String, completion: @escaping (Result<Bool, NSError>) -> ()) {
        // code
    }
    
}
