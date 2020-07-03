//
//  Data.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/25/20.
//  Copyright © 2020 DN. All rights reserved.
//

import MBProgressHUD

extension String: Error {}


struct ErrorResponse: Codable {
    let error: String
}


final class NetworkManager {
    
     //MARK:- Properities
    static let base = "https://dn-wallet.herokuapp.com/api"
    static var imageCache = NSCache<AnyObject, UIImage>()
    enum Endpoint {
        case login, register, phoneVerify, confirmMail
        case history
        case contacts, createContact, deleteContact(String)
        case charity, charityDetails(String)
        case heirs
        case me, editInfo

        var stringValue: String{
            switch self {
                case .login:                    return base + "/auth"  //POST
                case .register:                 return base + "/users/register" //POST
                case .history:                  return base + "/history" //GET
                case .contacts:                 return base + "/contacts" //GET
                case .me:                       return base + "/users/me" //GET
                case .charity:                  return base + "/charity" //GET
                case .charityDetails(let id):   return base + "/charity/\(id)" //GET
                case .heirs:                    return base + "/heirs" //GET
                case .deleteContact(let id):    return base + "/contacts/delete/\(id)" //DEL
                case .createContact:            return Endpoint.contacts.stringValue + "/create" //POST
                case .phoneVerify:              return base + "/verfiy" // POST
                case .confirmMail:              return base + "/users/forget-password" //POST
                case .editInfo:                 return base + "/users/info" //PUT
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
     //MARK:- Authentication
    
    //====================================
    // Sign in
    //====================================
    /*
    class func login(credintial: Login, comlpetion: @escaping(Result<LoginResponse, DNError>)-> Void) {
        taskForPOSTRequest(url: Endpoint.login.url, responseType: LoginResponse.self, body: credintial, comlpetion)
    }
    
    //====================================
    // Create Account
    //====================================
    class func register(with data: Register, completion: @escaping(Result<RegisterResponder, DNError>) -> Void) {
        taskForPOSTRequest(url: Endpoint.register.url, responseType: RegisterResponder.self, body: data, completion)
    }
 */
    
    //====================================
    // Verify Phone number
    //====================================
    class func verifyPhone(number: String, completion: @escaping (Result<Bool, DNError>) -> () ) {
        var request = URLRequest(url: Endpoint.phoneVerify.url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("auth.getUserToken()", forHTTPHeaderField: "a-auth-token")
        request.httpBody = try! JSONSerialization.data(withJSONObject: ["phoneNumber": number])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.invalidData))
                return
            }
            
            print("DDT1: \(String(describing: String(data: safeData, encoding: .utf8)))")
            
            completion(.success(true))
        }
        task.resume()
    }
    
    //====================================
    // check opt code for phone number
    //====================================
    
    class func checkPhoneCode(number: String, code: String, completion: @escaping (Result<Bool, DNError>) -> () ) {
        var request = URLRequest(url: Endpoint.phoneVerify.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("auth.getUserToken()", forHTTPHeaderField: "a-auth-token")
        request.httpBody = try! JSONSerialization.data(withJSONObject: ["phoneNumber": number, "code": code])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let safeData = data else {
                completion(.failure(.invalidData))
                return
            }
            print("DDT2: \(String(describing: String(data: safeData, encoding: .utf8)))")
            completion(.success(true))
        }
        task.resume()
    }
    
    //=========================
    // confirm Mail
    //=========================
    class func confirmEmail(email: String, code: String, completion:@escaping(Result<Bool, DNError>) -> ()) {
        var request = URLRequest(url: Endpoint.confirmMail.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue(AuthManager.shared.getUserToken(), forHTTPHeaderField: "a-auth-token")
        request.httpBody = try! JSONSerialization.data(withJSONObject: ["email": email, "code": code])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidToSendCode))
                return
            }
            
            completion(.success(true))
        }
        task.resume()
    }
    
    
    
    
    
     //MARK:- User Information
    
    //====================================
    // Get User's Info
    //====================================
    
    /// ask server to return the account information for the current user
    class func getUserAccountInfo(completion: @escaping(Result<AccountInfo, DNError>)-> Void) {
        taskForGETRequestWithToken(url: Endpoint.me.url, responseType: AccountInfo.self, completion)
    }
    
    //====================================
    // Edit Account
    //====================================
    class func editAccount(withObject object: [String: Any], completion: @escaping(Result<Bool, DNError>) -> () ) {
        var request = URLRequest(url: Endpoint.editInfo.url)
        request.httpMethod = "PUT"
        request.setValue("auth.getUserToken()", forHTTPHeaderField: "a-auth-token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: object)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(true))
        }
        task.resume()
    }
    
    //====================================
    // Get User's History
    //====================================
    
    /// ask server to get the financial history (consumption, send and donation) for the current user
    class func getUserHistory(completion: @escaping(Result<[History], DNError>) -> Void) {
        taskForGETRequestWithToken(url: Endpoint.history.url, responseType: [History].self, completion)
    }
     //MARK:- Contacts
    
    //====================================
    // Get all Contacts
    //====================================
    /// ask server to get the concats which belong to the current user
    class func getUserConcats(completion: @escaping(Result<[Contact], DNError>)-> Void) {
        taskForGETRequestWithToken(url: Endpoint.contacts.url, responseType: [Contact].self, completion)
    }
    
    //====================================
    // Create New Contact
    //====================================
    
    struct AddNewContact: Encodable {
        let email: String
    }
    /*
    class func addNewContact(WithEmail email: String, completion: @escaping(Result<Contact, String>) -> Void) {
        let data = AddNewContact(email: email)
        var request = URLRequest(url: Endpoint.createContact.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("auth.getUserToken()", forHTTPHeaderField: "x-auth-token")
        request.httpBody = try! JSONEncoder().encode(data)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.failure(DNError.unableToComplete.rawValue))
                return
            }
            /*
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(DNError.invalidResponse.rawValue))
                return
            }
             */
            guard let safeData = data else {
                completion(.failure(DNError.invalidData.rawValue))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(CreateContactResponse.self, from: safeData)
                if let err = decodedData.error {
                    completion(.failure(err))
                } else {
                    let contact = Contact(_id: decodedData.id!, userID: UserID(_id: decodedData.id!, name: decodedData.name!, email: decodedData.email!))
                    completion(.success(contact))
                }
                
            } catch {
                completion(.failure(DNError.invalidData.rawValue))
            }
        }
        task.resume()
    }
 */
    
    //====================================
    // Delete Contact
    //====================================
    struct deleteContactResponse: Codable {
        let error: String?
    }
    
    class func deleteContact(withID id: String, completion: @escaping(Result<Bool, String>) -> () ) {
        var request = URLRequest(url: Endpoint.deleteContact(id).url)
        let token = "auth.getUserToken()"
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error  {
                completion(.failure(DNError.unableToComplete.rawValue))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(DNError.invalidResponse.rawValue))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(DNError.invalidData.rawValue))
                return
            }
            do {
                let decode = JSONDecoder()
                let decodedData = try decode.decode(deleteContactResponse.self, from: safeData)
                if let err = decodedData.error {
                    completion(.failure(err))
                } else {
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DNError.invalidData.rawValue))
            }
            
        }
        task.resume()
    }
    
    class func addTransactionToHistoryWith(details: HistoryCategory, completion: @escaping (Bool, Error?) -> Void) {
//        taskForPOSTRequest(url: Endpoint.login.url, response: LoginResponse.self, body: details) { (success, error) in
//            if let success {
//                comlpetion(true, nil)
//            }else {
//                comlpetion(false, error)
//            }
//        }
    }
    /*
     //MARK:- Charity
    
    //====================================
    // Get Charity Initial data
    //====================================
    class func getCharityOrganizationInitialData(completion: @escaping(Result<[Charity], DNError>)-> Void) {
        taskForGETRequestWithToken(url: Endpoint.charity.url, responseType: [Charity].self, completion)
    }
    
    //====================================
    // Get Charity Details
    //====================================
    /// ask server to get the static information about charity organization
    class func getCharityOrganizationDetails(withID id:String, completion: @escaping(Result<CharityDetailsResponse, DNError>)-> Void) {
        taskForGETRequest(url: Endpoint.charityDetails(id).url, responseType: CharityDetailsResponse.self, completion)
    }
    
    //====================================
    // Get Charity Logo, Custom just for #cashe#
    //====================================
    class func loadImageWithStrURL(str: String, completion: @escaping (Result<UIImage, DNError>) -> () ) {
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
    */
    
    
    //MARK:- Transaction
    
    class func transactionAmount(_ amount: Double, to email: String, completion: @escaping(Bool, Error?)->Void) {
        // code ...
    }
    
    
    
    /// ask API to return list contain from at most two items which is user's heirs
    class func getUserHeirs(completion: @escaping(Result<[Heirs], DNError>) -> Void) {
        
    }
    
    //*******************************
    // ########### Generics #########
    //*******************************
    
    
    //========================================
    //MARK:- Generic: GETRequest without Token
    //========================================
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, _ completion: @escaping(Result<ResponseType, DNError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(handelTaskResponse(data, response, error, responseType))
        }
        task.resume()
    }
    
    
    //=====================================
    //MARK:- Generic: GEtRequest With Token
    //=====================================
    class func taskForGETRequestWithToken<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, _ completion: @escaping(Result<ResponseType, DNError>) -> Void) {
        
        var request = URLRequest(url: url)
        let token = "auth.getUserToken()"
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(handelTaskResponse(data, response, error, responseType))
        }
        task.resume()
    }
    
    
    //========================================
    //MARK:- Generic POSTRequest without Token
    //========================================
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, _ completion: @escaping(Result<ResponseType, DNError>)-> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(handelTaskResponse(data, response, error, responseType))
        }
        task.resume()
    }
    
    
    //===============================
    //MARK:- Generic: DELETERequest
    //===============================
    class func taskForDeleteRequestWithToken<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, _ completion: @escaping(Result<ResponseType, DNError>)-> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = "auth.getUserToken()"
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(handelTaskResponse(data, response, error, responseType))
        }
        task.resume()
    }
    
    //========================================
    //MARK:- Generic POSTRequest without Token
    //========================================
    class func taskForPOSTRequestWithToken<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, _ completion: @escaping(Result<ResponseType, DNError>)-> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = "AuthManager.shared.getUserToken()"
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(handelTaskResponse(data, response, error, responseType))
        }
        task.resume()
    }
    
    //========================================
    //MARK:- Helper Function
    //========================================
    private class func handelTaskResponse<ResponseType: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ responseType: ResponseType.Type) -> Result<ResponseType, DNError> {
        if let _ = error {
            return .failure(.unableToComplete)
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return .failure(.invalidResponse)
            /*
             guard let responseData = data else { return .failure(DNError.invalidResponse.rawValue)}
             do {
             let responseError = try JSONDecoder().decode(ErrorResponse.self, responseData)
             if let err = responseError {
                return .failure(err)
             }
             catch
             {
                return .failure(DNError.invalidResponse.rawValue)
             }
             */
            
        }
        
        guard let safeData = data else {
            return .failure(.invalidData)
            // return .failure(DNError.invalidData.rawValue)
        }
        
        do {
            let decoder = JSONDecoder()
            let responseObject = try decoder.decode(responseType.self, from: safeData)
            return .success(responseObject)
        } catch {
            return .failure(.invalidData)
            // return .failure(DNError.invalidData.rawValue)
        }
    }
    /*
    private class func NhandelTaskResponse<ResponseType: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ responseType: ResponseType.Type) -> Result<ResponseType, String> {
        if let _ = error {
            return .failure(.unableToComplete)
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            guard let responseData = data else { return .failure(DNError.invalidResponse.rawValue)}
            do {
                let responseError = try JSONDecoder().decode(ErrorResponse.self, responseData)
                if let err = responseError {
                    return .failure(err)
                }
                catch
                {
                    return .failure(DNError.invalidResponse.rawValue)
                }
                
        }
        
        guard let safeData = data else {
             return .failure(DNError.invalidData.rawValue)
        }
        
        do {
            let decoder = JSONDecoder()
            let responseObject = try decoder.decode(responseType.self, from: safeData)
            return .success(responseObject)
        } catch {
            return .failure(DNError.invalidData.rawValue)
        }
    }
 */
}
