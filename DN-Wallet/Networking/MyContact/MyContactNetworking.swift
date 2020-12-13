//
//  MyContactNetworking.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/3/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum MyContactNetworking {
    case getUserConcats
    case addNewContact(email: String)
    case deleteContact(id: String)
}

extension MyContactNetworking: TargetType {
    var baseURL: String {
        switch self {
            default: return "https://dn-wallet.herokuapp.com/api"
        }
    }
    
    var path: String {
        switch self {
            case .getUserConcats: return "/contacts"
            case .addNewContact:  return "/contacts/create"
            case .deleteContact(let id): return "/contacts/delete/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getUserConcats: return .get
            case .addNewContact:  return .post
            case .deleteContact:  return .delete
        }
    }
    
    var task: Task {
        switch self {
            case .getUserConcats: return .requestPlain
            case .addNewContact(let email):  return .requestParameters(["email":email])
            case .deleteContact: return .requestPlain
        }
    }
    
    var header: [String : String]? {
        switch self {
            default: return ["Content-Type": "application/json"]
        }
    }
    
    var tokenRequired: Bool {
        switch self {
            default: return true
        }
    }
}
