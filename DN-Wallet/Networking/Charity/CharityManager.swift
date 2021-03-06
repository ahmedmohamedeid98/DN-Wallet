//
//  CharityData.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/3/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol CharityManagerProtocol {
    func getCharityInitData(completion: @escaping(Result<[Charity], NSError>) -> ())
    func getCharityDetails(withId id: String, completion: @escaping(Result<CharityDetailsResponse, NSError>) -> ())
}

class CharityManager: BaseAPI<CharityNetworking>, CharityManagerProtocol {
    
    func getCharityInitData(completion: @escaping(Result<[Charity], NSError>) -> ()) {
        self.APIRequest(target: .getInitData, responseClass: [Charity].self, completion: completion)
    }
    
    func getCharityDetails(withId id: String, completion: @escaping(Result<CharityDetailsResponse, NSError>) -> ()) {
        self.APIRequest(target: .getDetails(id: id), responseClass: CharityDetailsResponse.self, completion: completion)
    }
}
