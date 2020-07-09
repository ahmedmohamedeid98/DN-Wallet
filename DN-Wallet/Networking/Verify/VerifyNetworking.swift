//
//  VerifyNetworking.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

enum VerifyNetworking {
    case sendPhoneVerifiCode(toPhone: String)
    case sendEmailVerifiCode
    case verifyPhone(withCode: String, andNumber: String)
    case verifyEmail(withCode: String)
}

extension VerifyNetworking: TargetType {
    var baseURL: String {
        return "https://dn-wallet.herokuapp.com/api"
    }
    
    var path: String {
        switch self {
            case .sendPhoneVerifiCode: return "/verfiy"
            case .sendEmailVerifiCode: return "/verfiy/email"
            case .verifyPhone: return "/verfiy"
            case .verifyEmail: return "/verfiy/email"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .sendPhoneVerifiCode: return .get
            case .sendEmailVerifiCode: return .get
            case .verifyPhone: return .post
            case .verifyEmail: return .post
        }
    }
    
    var task: Task {
        switch self {
            case .sendPhoneVerifiCode(let toPhone):
                return .requestParameters(["phoneNumber": toPhone])
            case .sendEmailVerifiCode:
                return .requestPlain
            case .verifyPhone(let withCode, let andNumber):
                return .requestParameters(["phoneNumber": andNumber, "code": withCode])
            case .verifyEmail(let withCode):
                return .requestParameters(["code": withCode])
        }
    }
    
    var header: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var tokenRequired: Bool {
        return true
    }
}
