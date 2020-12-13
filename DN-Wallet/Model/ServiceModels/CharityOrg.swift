//
//  Organization.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct Charity: Decodable, Hashable {
    var _id : String
    var name: String
    var email: String
    var org_logo: String
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self._id)
    }
}

struct CharityDetailsResponse: Codable {
    let name: String
    let address: String
    let founders: String
    let vision: String
    let about: String
    let phone: String
    let email: String
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lan: Double
}
