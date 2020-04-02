//
//  Data.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/25/20.
//  Copyright © 2020 DN. All rights reserved.
//


class Data {
    
    static let base = "https://hidden-sea-27440.herokuapp.com/"
    
    enum Endpoint {
        case login
        case register
        case history
        case concats
        case charity
        case account_info
        
        var stringValue: String{
            switch self {
            case .login:
                return Data.base + "/auth"
            case .register:
                return Data.base + "/users"
            case .history:
                return Data.base + "/history"
            case .concats:
                return Data.base + "/concats"
            case .account_info:
                return Data.base + "/account_info"
            case .charity:
                return Data.base + "/charity"

            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    /// ask server to return the account information for the current user
    class func getUserAccountInfo(completion: @escaping(AccountInfo?, Error?)-> Void) {
        taskForGETRequest(url: Endpoint.account_info.url, response: AccountInfo.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion(nil, error)
            }
        }
    }
    /// ask server to get the financial history (consumption, send and donation) for the current user
    class func getUserHistory(completion: @escaping([History], Error?) -> Void) {
        taskForGETRequest(url: Endpoint.history.url, response: [History].self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion([], error)
            }
        }
    }
    /// ask server to get the concats which belong to the current user
    class func getUserConcats(completion: @escaping([Contact], Error?)-> Void) {
        taskForGETRequest(url: Endpoint.concats.url, response: [Contact].self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion([], error)
            }
        }
        
    }
    /// ask server to get the static information about charity organization
    class func getCharityOrganizationDetails(completion: @escaping([CharityOrg], Error?)-> Void) {
        taskForGETRequest(url: Endpoint.charity.url, response: [CharityOrg].self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion([], error)
            }
        }
        
    }
    
    class func login(credintial: Login, comlpetion: @escaping(LoginResponse?, Error?)-> Void) {
        taskForPOSTRequest(url: Endpoint.login.url, response: LoginResponse.self, body: credintial) { (response, error) in
            if let response = response {
                comlpetion(response, nil)
            }else {
                comlpetion(nil, error)
            }
        }
    }
    
    class func register(with data: Register, completion: @escaping(RegisterResponder?, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoint.register.url, response: RegisterResponder.self, body: data) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion(nil, error)
            }
        }
    }
    
    /// Generic func preform get (fetch) request
    /// - Parameters:
    ///   - url: url which you ask server to fetch data from it.
    ///   - response: struct which confirm codable protocol.
    ///   - completion: closure func with return the codable struct object if the fetching process success and error otherwise.
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    /// Generic func preform POST (create) request
    /// - Parameters:
    ///   - url: url which you ask server to post data to it.
    ///   - response: struct which confirm codable protocol.
    ///   - completion: closure func with return the codable struct object if the posting process success and error otherwise.
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping(ResponseType?, Error?)-> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}