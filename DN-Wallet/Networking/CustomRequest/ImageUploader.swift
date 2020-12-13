//
//  ImageUploader.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/27/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

struct ImageRequest {
    let attachment: String
    let fileName: String
}

class ImageUploader {
    static let shared = ImageUploader()
    private lazy var auth:UserAuthProtocol = UserAuth()
    private init() {}
    //formFields: [String: String], imageData: Data
    func uploadImage(requestURL: URL, imageRequest: ImageRequest, completion: @escaping(Result<SuccessResponse, NSError>) -> () ) {
        
        
        let urlString   = "https://dn-wallet.herokuapp.com/api/users/pic"
        let url         = URL(string: urlString)!
        let lineBreak   = "\r\n"
        
        var request     = URLRequest(url: url)
        let boundary = "----------------------------\(UUID().uuidString)"
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(auth.getUserToken(), forHTTPHeaderField: "x-auth-token")
        
        var requestData = Data()
        requestData.append("--\(boundary)\r\n".data(using: .utf8)!)
        requestData.append("content-disposition; form-data; name=\"attachment\" \(lineBreak + lineBreak)".data(using: .utf8)!)
        requestData.append(imageRequest.attachment.data(using: .utf8)!)
        
        requestData.append("--\(boundary)\r\n".data(using: .utf8)!)
        requestData.append("content-disposition; form-data; name=\"fileName\" \(lineBreak + lineBreak)".data(using: .utf8)!)
        requestData.append(imageRequest.fileName.data(using: .utf8)!)
        
        requestData.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        request.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        request.httpBody = requestData
        
        //        let httpBody = NSMutableData()
        //
        //        for (key, value) in formFields {
        //          httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
        //        }
        //
        //        httpBody.append(convertFileData(fieldName: "image_field",
        //                                        fileName: "imagename.png",
        //                                        mimeType: "image/png",
        //                                        fileData: imageData,
        //                                        using: boundary))
        //
        //        httpBody.appendString("--\(boundary)\r\n")
        //
        //        request.httpBody = httpBody as Data
        
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
    
    func uploadImage(withPath fullPath: String ) {
        let url = "http://server/upload"
        let img = UIImage(contentsOfFile: fullPath)
        let data: Data = img!.jpegData(compressionQuality: 1)!
        
//        sendFile(urlPath: url,
//                 fileName:"one.jpg",
//                 data:data,
//                 completionHandler: {
//            (result:Bool, isNoInternetConnection:Bool) -> Void in
//
//            // ...
//            NSLog("Complete: \(result)")
//            }
//        )
    }
    func generateBoundary() -> String {
        return "----------------------------\(UUID().uuidString)"
    }
    
    func sendFile(urlPath:String, fileName:String, data:Data, completionHandler: @escaping (URLResponse?, Data?, NSError?) -> Void){
        let url: URL = URL(string: urlPath)!
        var request1: URLRequest = URLRequest(url: url)
        
        request1.httpMethod = "POST"
        
        let boundary = generateBoundary()
        let fullData = photoDataToFormData(data: data,boundary:boundary,fileName:fileName)
        
        request1.setValue("multipart/form-data; boundary=" + boundary,
                          forHTTPHeaderField: "Content-Type")
        
        // REQUIRED!
        request1.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
        
        request1.httpBody = fullData
        request1.httpShouldHandleCookies = false
        
        let queue:OperationQueue = OperationQueue()
        
        //URLSession.shared.dataTask(with: <#T##URLRequest#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
        //URLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:completionHandler)
    }
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
    func photoDataToFormData(data:Data, boundary:String, fileName:String) -> Data {
        var fullData = NSMutableData()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(using: .utf8)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        
        fullData.append(lineTwo.data(using: .utf8)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(using: .utf8)!)
        
        // 4
        fullData.append(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(using: .utf8)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(using: .utf8)!)
        
        return fullData as Data
    }

}
extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
