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
    func editMyAccount(withData data: [String: Any], completion: @escaping(Result<Bool, NSError>) -> ())
    func getMyHisory(completion: @escaping(Result<[History], NSError>) -> ())
    
}

class MeManager: BaseAPI<MeNetworking>, MeManagerProtocol {
    
    func getMyAccountInfo(completion: @escaping(Result<AccountInfo, NSError>) -> ()) {
        self.APIRequest(target: .getMyBasicInfo, responseClass: AccountInfo.self, completion: completion)
    }
    
    func editMyAccount(withData data: [String: Any], completion: @escaping(Result<Bool, NSError>) -> ()) {
        self.APIRequest(target: .editAcount(withObject: data), responseClass: Bool.self, completion: completion)
    }
    
    func getMyHisory(completion: @escaping(Result<[History], NSError>) -> ()) {
        self.APIRequest(target: .getMyHistory, responseClass: [History].self, completion: completion)
    }
    
}
