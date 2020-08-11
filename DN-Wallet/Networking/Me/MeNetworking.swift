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
    case addHeir(PostHeir)
    case getHeir
    case editHeir(PostHeir)
}

extension MeNetworking: TargetType {
    var baseURL: String {
        return "https://dn-wallet.herokuapp.com/api"
    }
    
    var path: String {
        switch self {
            case .getMyBasicInfo:   return "/users/me"
            case .editAcount:       return "/users/info"
            case .getMyHistory:     return "/cards/history"
            case .addHeir:          return "/users/heir"
            case .getHeir:          return "/users/heir"
            case .editHeir:         return "/users/heir"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getMyBasicInfo:   return .get
            case .editAcount:       return .put
            case .getMyHistory:     return .get
            case .addHeir:          return .post
            case .getHeir:          return .get
            case .editHeir:         return .put
        }
    }
    
    var task: Task {
        switch self {
            case .getMyBasicInfo:               return .requestPlain
            case .editAcount(let withObject):   return .requestParameters(withObject)
            case .getMyHistory:                 return .requestPlain
            case .addHeir(let h):               return .requestParameters(["first_heir": h.first_heir, "second_heir": h.second_heir, "precentage": h.precentage])
            case .getHeir:                      return .requestPlain
            case .editHeir(let h):              return .requestParameters(["first_heir": h.first_heir, "second_heir": h.second_heir, "precentage": h.precentage])
        }
    }
    
    var header: [String : String]? {
        return ["ContentType": "application/json"]
    }
    
    var tokenRequired: Bool {
        return true
    }
}
