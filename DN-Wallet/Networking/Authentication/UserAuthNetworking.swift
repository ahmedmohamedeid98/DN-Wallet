//
//  UserAuthNetworking.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/3/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum UserAuthNetworking {
    case login(data: Login)
    case register(data: Register)
}

extension UserAuthNetworking: TargetType {
    
    var baseURL: String {
        switch self {
            default: return "https://dn-wallet.herokuapp.com/api"
        }
    }
    
    var path: String {
        switch self {
            case .login: return "/auth"
            case .register: return "/users/register"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .login: return .post
            case .register: return .post
        }
    }
    
    var task: Task {
        switch self {
            case .login(let data): return .requestParameters(["email": data.email, "password": data.password])
            case .register(let data): return .requestParameters(["name": data.name, "email": data.email, "password": data.password, "confirm_password": data.confirm_password])
        }
    }
    
    var header: [String : String]? {
        switch self {
            default: return ["Content-Type": "application/json"]
        }
    }
    
    var tokenRequired: Bool {
        switch self {
            default: return false
        }
    }
}
