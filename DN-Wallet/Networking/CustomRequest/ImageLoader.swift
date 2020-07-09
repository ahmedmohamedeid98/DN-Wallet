//
//  ImageLoader.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {}
    
    private var imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImageWithStrURL(str: String, completion: @escaping (Result<UIImage, DNError>) -> () ) {
        let url = URL(string: str)!
        if let image = imageCache.object(forKey: str as AnyObject) {
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
            self.imageCache.setObject(image, forKey: str as AnyObject)
            completion(.success(image))
            
        }
        task.resume()
    }
}
