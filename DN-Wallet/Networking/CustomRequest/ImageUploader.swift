//
//  ImageUploader.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

class ImageUploader {
    static let shared = ImageUploader()
    private init() {}
    
    func uploadImage(formFields: [String: String], imageData: Data, completion: @escaping(Result<SuccessResponse, NSError>) -> () ) {
        
    
        let urlString   = ""
        let url         = URL(string: urlString)!
        
        var request     = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()

        for (key, value) in formFields {
          httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
        }

        httpBody.append(convertFileData(fieldName: "image_field",
                                        fileName: "imagename.png",
                                        mimeType: "image/png",
                                        fileData: imageData,
                                        using: boundary))

        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("there is an error")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("status Code not = 200")
                return
            }
            
            let successRes = SuccessResponse(success: "image upload Successfully")
            completion(.success(successRes))
            
        }.resume()
        
    }
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
    
    
    
}
extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
