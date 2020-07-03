//
//  BaseAPI.swift
//  NetworkLayerWithGenerics-IOS13
//
//  Created by Mac OS on 7/2/20.
//  Copyright © 2020 Ahmed Eid. All rights reserved.
//

import Foundation
import KeychainSwift

struct NoResponse: Decodable {
    // just for requests which have no response if success like delete
}

class BaseAPI<T: TargetType> {
    private let keychain = KeychainSwift(keyPrefix: keys.keyPrefix)
    
    
    func APIRequest<M: Decodable>(target: T ,responseClass: M.Type, completion: @escaping (Result<M, NSError>) -> ()) {
        
        guard let url = URL(string: target.baseURL + target.path) else {
            print("Debug::Error-> Invalid URL, con not construct url from base and path.")
            return
        }
        let params = buildParameters(task: target.task)
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = target.header
        
        if target.tokenRequired {
            request.setValue(keychain.get(keys.token), forHTTPHeaderField: "x-auth-token")
        }
        
        if let body = params {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("No Body Coming")
            }
            
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                print("Debug::Error-> server return error, request can not compelete")
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.unableToComplete])
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Debug::Warning-> No Server Response")
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.invalidResponse])
                completion(.failure(error))
                return
            }
            let invalidDataError = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.invalidData])
            if response.statusCode == 200 {
                
                if !target.haveResponseClass {
                    //completion(.success(try! JSONDecoder().decode(M.self, from: Data.in))
                    return
                }

                
                guard let safeData = data else {
                    print("Debug::Error-> no data comming")
                    completion(.failure(invalidDataError))
                    return
                }
                
                guard let result = try? JSONDecoder().decode(M.self, from: safeData) else {
                    print("Debug::Error-> Can not parse give date to your response class")
                    completion(.failure(invalidDataError))
                    return
                }
                
                print("Debug::Success-> Parse Data Successfully!")
                completion(.success(result))
                
            } else {
                // server return an error
                guard let safeData = data else {
                    print("Debug::Error-> status code not 200 and also no data comming")
                    completion(.failure(invalidDataError))
                    return
                }
                
                guard let err = try? JSONDecoder().decode(ErrorResponse.self, from: safeData) else {
                    completion(.failure(invalidDataError))
                    return
                }
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: err.error])
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func buildParameters(task: Task) -> [String: Any]? {
        switch task {
            
            case .requestPlain:
                return nil
            case .requestParameters(let parameters):
                return parameters
        }
    }
}
