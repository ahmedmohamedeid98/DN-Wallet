//
//  Organization.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct CharityOrg: Codable, Hashable {
    var identifier: UUID = UUID()
    
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
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.identifier)
    }
    static func == (lhs: CharityOrg, rhs: CharityOrg) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct Location: Codable {
    let lat: Double
    let log: Double
}
