//
//  MeManager.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

protocol MeManagerProtocol {
    func getMyAccountInfo(completion: @escaping(Result<AccountInfo, NSError>) -> ())
    func editMyAccount(withData data: [String: Any], completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func getMyHisory(completion: @escaping(Result<History, NSError>) -> ())
    func getMyHeirs(completion: @escaping(Result<[getHeir], NSError>) -> ())
    func addHeir(heir: PostHeir, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    func updateHeir(heir: PostHeir, completion: @escaping(Result<SuccessResponse, NSError>) -> ())
    
}

class MeManager: BaseAPI<MeNetworking>, MeManagerProtocol {

    func getMyAccountInfo(completion: @escaping(Result<AccountInfo, NSError>) -> ()) {
        self.APIRequest(target: .getMyBasicInfo, responseClass: AccountInfo.self, completion: completion)
    }
    
    func editMyAccount(withData data: [String: Any], completion: @escaping(Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .editAcount(withObject: data), responseClass: SuccessResponse.self, completion: completion)
    }
    
    // not add for now
    func getMyHisory(completion: @escaping(Result<History, NSError>) -> ()) {
        self.APIRequest(target: .getMyHistory, responseClass: History.self, completion: completion)
    }
    
    func getMyHeirs(completion: @escaping (Result<[getHeir], NSError>) -> ()) {
        APIRequest(target: .getHeir, responseClass: [getHeir].self, completion: completion)
    }
    
    func addHeir(heir: PostHeir, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        APIRequest(target: .addHeir(heir), responseClass: SuccessResponse.self, completion: completion)
    }
    
    func updateHeir(heir: PostHeir, completion: @escaping (Result<SuccessResponse, NSError>) -> ()) {
        APIRequest(target: .editHeir(heir), responseClass: SuccessResponse.self, completion: completion)
    }
}
