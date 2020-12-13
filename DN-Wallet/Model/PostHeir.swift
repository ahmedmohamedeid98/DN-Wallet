//
//  Hier.swift
//  DN-Wallet
//
//  Created by Mac OS on 8/11/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

struct PostHeir: Codable {
    let first_heir: String
    let second_heir: String
    let precentage : Int
}

struct getHeir: Codable {
    let heir1: String
    let heir2: String
    let heir1Precentage: Int
}
