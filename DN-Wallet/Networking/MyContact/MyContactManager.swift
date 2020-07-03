//
//  MyContactManager.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/3/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol MyContactManagerProtocol {
    func getUserContacts(completion: @escaping(Result<[Contact], NSError>) -> () )
    func addNewContact(withEmail mail: String, completion: @escaping(Result<CreateContactResponse, NSError>) -> ())
    func deleteContact(WithId id: String, completion: @escaping(Result<Bool, NSError>) -> () )
}

class MyContactManager: BaseAPI<MyContactNetworking>, MyContactManagerProtocol {
    func getUserContacts(completion: @escaping(Result<[Contact], NSError>) -> () ) {
        APIRequest(target: .getUserConcats, responseClass: [Contact].self, completion: completion)
    }
    
    func addNewContact(withEmail mail: String, completion: @escaping(Result<CreateContactResponse, NSError>) -> () ) {
        APIRequest(target: .addNewContact(email: mail), responseClass: CreateContactResponse.self, completion: completion)
    }
    
    func deleteContact(WithId id: String, completion: @escaping(Result<Bool, NSError>) -> () ) {
        APIRequest(target: .deleteContact(id: id), responseClass: NoResponse.self) { (result) in
            switch result {
                case .success(_):
                    completion(.success(true))
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
}
