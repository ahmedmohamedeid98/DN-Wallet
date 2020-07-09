//
//  MeNetworking.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum MeNetworking {
    case getMyBasicInfo
    case editAcount(withObject: [String: Any])
    case getMyHistory
}

extension MeNetworking: TargetType {
    var baseURL: String {
        return "https://dn-wallet.herokuapp.com/api"
    }
    
    var path: String {
        switch self {
            case .getMyBasicInfo:  return "/users/me"
            case .editAcount: return "/users/info"
            case .getMyHistory: return "/history"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getMyBasicInfo: return .get
            case .editAcount: return .put
            case .getMyHistory: return .get
        }
    }
    
    var task: Task {
        switch self {
            case .getMyBasicInfo: return .requestPlain
            case .editAcount(let withObject): return .requestParameters(withObject)
            case .getMyHistory: return .requestPlain
        }
    }
    
    var header: [String : String]? {
        return ["ContentType": "application/json"]
    }
    
    var tokenRequired: Bool {
        return true
    }
}
