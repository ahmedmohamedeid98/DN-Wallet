//
//  User.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

struct User {
    
    private(set) var username: String
    private(set) var email: String
    private(set) var password: String
    private(set) var phone: String
    private(set) var country: String
    private(set) var gender: String?
    private(set) var job: String?
    private(set) var photoLink: String?
    
    init(username: String, email: String, password: String, phone: String, country: String, gender: String? = nil, job: String? = nil, photoLink: String? = nil) {
        self.username = username
        self.email = email
        self.password = password
        self.phone = phone
        self.country = country
        if let _gender = gender {
            self.gender = _gender
        }
        if let _job = job {
            self.job = _job
        }
        if let _photoLink = photoLink {
            self.photoLink = _photoLink
        }
    }
}
