//
//  ResetNetworking.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum ResetNetworking {
    case forgetPassword(forEmail: String)
    case forgetPasswordCheck(email: String, code: String)
    case resetPassword(newPassword: String, code: String, email: String)
    case updatePassword(oldPassword: String, newPassword: String)
}

extension ResetNetworking: TargetType {
    var baseURL: String {
        return "https://dn-wallet.herokuapp.com/api"
    }
    
    var path: String {
        switch self {
            case .forgetPassword: return "/users/forget-password"
            case .forgetPasswordCheck: return "/users/forget-password-check"
            case .resetPassword: return "/users/rest-password"
            case .updatePassword: return "/users/new-password"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .forgetPassword: return .post
            case .forgetPasswordCheck: return .post
            case .resetPassword: return .post
            case .updatePassword: return .put
        }
    }
    
    var task: Task {
        switch self {
            
            case .forgetPassword(let forEmail):
                return .requestParameters(["email": forEmail])
            case .forgetPasswordCheck(let email, let code):
                return .requestParameters(["email": email, "code": code])
            case .resetPassword(let newPassword, let code, let email):
                return .requestParameters(["email": email, "code": code, "password": newPassword])
            case .updatePassword(let oldPassword, let newPassword):
                return . requestParameters(["password": oldPassword, "newPassword": newPassword])
        }
    }
    
    var header: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var tokenRequired: Bool {
        switch self {
            case .forgetPassword: return false
            case .forgetPasswordCheck: return false
            case .resetPassword: return false
            case .updatePassword: return true
            
        }
    }
}
