//
//  Contact.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

// convert this struct to class to enable Diffable Data Source reload item when updated it.
// struct was confirm Hashable Protocol , but we can replace it by NSObject which confirm Hashable Protocol.
class Contact: NSObject, Codable {
    var username:String
    var email:String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
    var identifier: UUID = UUID()

    static func == (lhs: Contact, rhs: Contact) -> Bool{
        return lhs.identifier == rhs.identifier
    }
}
