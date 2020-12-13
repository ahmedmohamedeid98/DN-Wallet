//
//  Login.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct Login: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
}
