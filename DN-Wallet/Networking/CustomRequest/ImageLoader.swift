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
    
    private var cache = NSCache<NSString, UIImage>()
    
    func loadImageWithStrURL(str: String, completion: @escaping (Result<UIImage, DNError>) -> () ) {
        
        guard let url   = URL(string: str) else { return }
        print("url: \(url)")
        let cacheKey    = NSString(string: str)
        if let image    = cache.object(forKey: cacheKey) {
            completion(.success(image))
            return
        }
        
        let task  = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error         == nil else { return }
            guard let response  = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let safeData  = data else { return }
            guard let image     = UIImage(data: safeData) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            completion(.success(image))
        }
        task.resume()
    }
}
