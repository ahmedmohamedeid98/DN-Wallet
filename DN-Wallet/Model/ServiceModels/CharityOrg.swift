//
//  Organization.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct CharityResponse: Codable {
    let _id : String
    let name: String
    let email: String
    let org_logo: String
}

final class Charity:  Hashable {
    var id : String
    var name: String
    var email: String
    var link: String
    
    var identifier: UUID = UUID()
    
    init(id: String, name: String, email: String, link: String) {
        self.id = id
        self.name = name
        self.email = email
        self.link = link
        
    }
    func hash(into hasher: inout Hasher) {
        return hasher.combine(self.identifier)
    }
    static func == (lhs: Charity, rhs: Charity) -> Bool {
        return lhs.identifier == rhs.identifier
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
