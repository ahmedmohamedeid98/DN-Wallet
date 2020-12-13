//
//  User.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct User {
    
    var username: String
    var email: String
    var password: String
    var phone: String?
    var country: String?
    var gender: String?
    var job: String?
    var photo: String?
    
    init(username: String, email: String, password: String, phone: String? = nil, country: String? = nil, gender: String? = nil, job: String? = nil, photoLink: String? = nil) {
        self.username = username
        self.email = email
        self.password = password
        
        if let _phone = phone {
            self.phone = _phone
        }
        
        if let _country = country {
            self.country = _country
        }
        
        if let _gender = gender {
            self.gender = _gender
        }
        
        if let _job = job {
            self.job = _job
        }
        
        if let _photoLink = photoLink {
            self.photo = _photoLink
        }
    }
}
