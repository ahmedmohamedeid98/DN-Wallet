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
    case resetPassword(newPassword: String, code: String, email: String)
    case updatePassword(newPassword: String)
}

extension ResetNetworking: TargetType {
    var baseURL: String {
        return "https://dn-wallet.herokuapp.com/api"
    }
    
    var path: String {
        switch self {
            case .forgetPassword: return "/users/forget-password"
            case .resetPassword: return ""
            case .updatePassword: return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .forgetPassword: return .delete
            case .resetPassword: return .delete
            case .updatePassword: return .delete
        }
    }
    
    var task: Task {
        switch self {
            
            case .forgetPassword(let forEmail):
                return .requestParameters(["email": forEmail])
            case .resetPassword(let newPassword, let code, let email):
                return .requestParameters(["password": newPassword, "code": code, "email": email])
            case .updatePassword(let newPassword):
                return .requestParameters(["password": newPassword])
        }
    }
    
    var header: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var tokenRequired: Bool {
        switch self {
            case .forgetPassword: return false
            case .resetPassword: return false
            case .updatePassword: return true
        }
    }
    
    var haveResponseClass: Bool {
        return false
    }
    
    
}
