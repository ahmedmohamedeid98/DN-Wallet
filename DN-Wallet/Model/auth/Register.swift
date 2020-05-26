//
//  User.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct Register: Codable {
    let email: String
    let password: String
    let username: String
    let phone: String
}

struct RegisterResponder: Codable {
    let id: String
    let token: String
}
