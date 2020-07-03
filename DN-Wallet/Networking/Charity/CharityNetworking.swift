//
//  CharityNetworking.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/3/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum CharityNetworking {
    case getInitData
    case getDetails(id: String)
}

extension CharityNetworking: TargetType {
    
    
    var baseURL: String {
        switch self {
            default: return "https://dn-wallet.herokuapp.com/api"
        }
    }
    
    var path: String {
        switch self {
            case .getInitData: return "/charity"
            case .getDetails(let id): return "/charity/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            default: return .get
        }
    }
    
    var task: Task {
        switch self {
            default: return .requestPlain
        }
    }
    
    var header: [String : String]? {
        switch self {
            default: return ["Content-Type": "application/json"]
        }
    }
    
    var tokenRequired: Bool {
        switch self {
            case .getInitData: return true
            case .getDetails:  return false
        }
    }
    
    var haveResponseClass: Bool {
        return true
    }
    
}
