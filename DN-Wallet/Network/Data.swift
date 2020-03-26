//
//  Data.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/25/20.
//  Copyright © 2020 DN. All rights reserved.
//


class Data {
    
    static let base = "link"
    
    enum Endpoint {
        case login
        case register
        case history
        case concats
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
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    /// ask server to return the account information for the current user
    class func getUserAccountInfo(completion: @escaping([String], Error?)-> Void) {
        
    }
    /// ask server to get the financial history (consumption, send and donation) for the current user
    class func getUserHistory(completion: @escaping([String], Error?) -> Void) {
        //taskForGETRequest(url: Endpoint.history.url, response: <#T##Decodable.Protocol#>, completion: <#T##(Decodable?, Error?) -> Void#>)
    }
    /// ask server to get the concats which belong to the current user
    class func getUserConcats(completion: @escaping([String], Error?)-> Void) {
        
    }
    /// ask server to get the static information about charity organization
    class func getCharityOrganizationDetails(completion: @escaping([String], Error?)-> Void) {
        
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
