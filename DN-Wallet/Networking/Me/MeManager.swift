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
    func getMyHisory(completion: @escaping(Result<[History], NSError>) -> ())
    
}

class MeManager: BaseAPI<MeNetworking>, MeManagerProtocol {
    
    override init() {
        print("new Object was created")
    }
    
    deinit {
        print("Object was dealocated")
    }
    
    func getMyAccountInfo(completion: @escaping(Result<AccountInfo, NSError>) -> ()) {
        self.APIRequest(target: .getMyBasicInfo, responseClass: AccountInfo.self, completion: completion)
    }
    
    func editMyAccount(withData data: [String: Any], completion: @escaping(Result<SuccessResponse, NSError>) -> ()) {
        self.APIRequest(target: .editAcount(withObject: data), responseClass: SuccessResponse.self, completion: completion)
    }
    
    // not add for now
    func getMyHisory(completion: @escaping(Result<[History], NSError>) -> ()) {
        self.APIRequest(target: .getMyHistory, responseClass: [History].self, completion: completion)
    }
    
}
