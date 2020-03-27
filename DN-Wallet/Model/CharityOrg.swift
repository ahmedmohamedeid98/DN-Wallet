//
//  Organization.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct CharityOrg: Codable {
    let id:String
    let title: String
    let email:String
    let logoLink : String
    let imageLink: String
    let location: Location
    let concats: String
    let address: String
    let founders: String
    let vision: String
    let about: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case email
        case logoLink = "org_logo"
        case imageLink = "org_image"
        case location
        case concats
        case address
        case founders
        case vision
        case about
    }
}

struct Location: Codable {
    let lat: Double
    let log: Double
}
