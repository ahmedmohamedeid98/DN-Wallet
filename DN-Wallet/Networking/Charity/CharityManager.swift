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
    func loadImageWithStrURL(str: String, completion: @escaping (Result<UIImage, DNError>) -> () )
}

class CharityManager: BaseAPI<CharityNetworking>, CharityManagerProtocol {
    
    func getCharityInitData(completion: @escaping(Result<[Charity], NSError>) -> ()) {
        self.APIRequest(target: .getInitData, responseClass: [Charity].self, completion: completion)
    }
    
    func getCharityDetails(withId id: String, completion: @escaping(Result<CharityDetailsResponse, NSError>) -> ()) {
        self.APIRequest(target: .getDetails(id: id), responseClass: CharityDetailsResponse.self, completion: completion)
    }
    
    func loadImageWithStrURL(str: String, completion: @escaping (Result<UIImage, DNError>) -> () ) {
        let url = URL(string: str)!
        if let image = NetworkManager.imageCache.object(forKey: str as AnyObject) {
            completion(.success(image))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let safeData = data, let image = UIImage(data: safeData) else {
                completion(.failure(.invalidData))
                return
            }
            //Cach
            NetworkManager.imageCache.setObject(image, forKey: str as AnyObject)
            completion(.success(image))
            
        }
        task.resume()
    }
}
