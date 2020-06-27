//
//  Contact.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

// convert this struct to class to enable Diffable Data Source reload item when updated it.
// struct was confirm Hashable Protocol , but we can replace it by NSObject which confirm Hashable Protocol.


// get all contacts
struct Contact: Codable, Hashable {
    let _id : String
    let userID: UserID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    static func ==(lhs: Contact, rhs:Contact) -> Bool {
        return lhs._id == rhs._id
    }
}

struct UserID: Codable {
    let _id: String
    let name: String
    let email: String
}

// creating new contact
struct CreateContactResponse: Codable {
    let id: String?
    let name: String?
    let email: String?
    let error: String?
}
/*
// class which populate in tableView
class Contact: NSObject {
    var username:String
    var email:String
    var id: String
    
    init(username: String, email: String, id: String, identifier: String) {
        self.username = username
        self.email = email
        self.identifier = identifier
        self.id = id
    }
    var identifier: String

    static func == (lhs: Contact, rhs: Contact) -> Bool{
        return lhs.identifier == rhs.identifier
    }
}
*/
