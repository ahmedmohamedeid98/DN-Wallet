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
    let error: String?
}


final class DNData {
    
     //MARK:- Properities
    
    static let base = "https://dn-wallet.herokuapp.com/api"
    static var imageCache = NSCache<AnyObject, UIImage>()
    enum Endpoint {
        case login, register, phoneVerify
        case history
        case contacts, createContact, deleteContact(String)
        case charity, charityDetails(String)
        case heirs
        case account_info
        case UTCDateTime
        
        var stringValue: String{
            switch self {
                case .login: return base + "/auth"
                case .register: return base + "/users/register"
                case .history: return base + "/history"
                case .contacts: return base + "/contacts"
                case .account_info: return base + "/account_info"
                case .charity: return base + "/charity"
                case .charityDetails(let id): return base + "/charity/\(id)"
                case .heirs: return base + "/heirs"
                case .UTCDateTime: return "http://worldclockapi.com/api/json/utc/now"
                case .deleteContact(let id): return base + "/contacts/delete/\(id)"
                case .createContact: return Endpoint.contacts.stringValue + "/create"
                case .phoneVerify: return base + "/verfiy"
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
    
    /// login method, ask API to return a token
    class func login(credintial: Login, onView view: UIView, comlpetion: @escaping(LoginResponse?, Error?)-> Void) {
        Hud.showLoadingHud(onView: view)
        taskForPOSTRequest(url: Endpoint.login.url, response: LoginResponse.self, body: credintial) { (response, error) in
            if let response = response {
                comlpetion(response, nil)
            }else {
                comlpetion(nil, error)
            }
        }
    }
    
    //====================================
    // Create Account
    //====================================
    
    /// ask API to create account, and return a user token
    class func register(with data: Register, onView view: UIView, completion: @escaping(RegisterResponder?, Error?) -> Void) {
        Hud.showLoadingHud(onView: view)
        taskForPOSTRequest(url: Endpoint.register.url, response: RegisterResponder.self, body: data) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion(nil, error)
            }
        }
    }
    
    //====================================
    // Verify Phone number
    //====================================
    
    class func verifyPhone(number: String, completion: @escaping (Bool) -> () ) {
        var request = URLRequest(url: Endpoint.phoneVerify.url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Auth.shared.getUserToken(), forHTTPHeaderField: "a-auth-token")
        request.httpBody = try! JSONSerialization.data(withJSONObject: ["phoneNumber": number])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(false)
                return
            }
            if let safeData = data {
                print("DDT1: \(String(data: safeData, encoding: .utf8))")
                let decoder = JSONDecoder()
                do {
                    let res = try decoder.decode(ErrorResponse.self, from: safeData)
                    if res.error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    //====================================
    // check opt code for phone number
    //====================================
    
    class func checkPhoneCode(number: String, code: String, completion: @escaping (Bool) -> () ) {
        var request = URLRequest(url: Endpoint.phoneVerify.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Auth.shared.getUserToken(), forHTTPHeaderField: "a-auth-token")
        request.httpBody = try! JSONSerialization.data(withJSONObject: ["phoneNumber": number, "code": code])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(false)
                return
            }
            if let safeData = data {
                print("DDT2: \(String(data: safeData, encoding: .utf8))")
                let decoder = JSONDecoder()
                do {
                    let res = try decoder.decode(ErrorResponse.self, from: safeData)
                    if res.error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
     //MARK:- User Information
    
    //====================================
    // Get User's Info
    //====================================
    
    /// ask server to return the account information for the current user
    class func getUserAccountInfo(onView view: UIView, completion: @escaping(AccountInfo?, Error?)-> Void) {
        taskForGETRequest(url: Endpoint.account_info.url, response: AccountInfo.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion(nil, error)
            }
        }
    }
    
    //====================================
    // Get User's History
    //====================================
    
    /// ask server to get the financial history (consumption, send and donation) for the current user
    class func getUserHistory(onView view: UIView, completion: @escaping([History], Error?) -> Void) {
        taskForGETRequest(url: Endpoint.history.url, response: [History].self) { (response, error) in
            if let response = response {
                completion(response, nil)
            }else {
                completion([], error)
            }
        }
    }
     //MARK:- Contacts
    
    //====================================
    // Get all Contacts
    //====================================
    /// ask server to get the concats which belong to the current user
    class func getUserConcats(onView view: UIView, completion: @escaping([Contact], Error?)-> Void) {
        Hud.showLoadingHud(onView: view)
        taskForGETRequestWithToken(url: Endpoint.contacts.url, response: [ContactResponse].self) { (response, error) in
            if let response = response {
                var contacts: [Contact] = []
                for item in response {
                    contacts.append(Contact(username: item.userID.name, email: item.userID.email, id: item.userID._id, identifier: item._id))
                }
                completion(contacts, nil)
            }else {
                completion([], error)
            }
        }
        
    }
    
    //====================================
    // Create New Contact
    //====================================
    
    struct AddNewContact: Encodable {
        let email: String
    }
    
    class func addNewContact(WithEmail email: String, onView view: UIView, completion: @escaping(Bool, String?) -> Void) {
        Hud.showLoadingHud(onView: view, withLabel: "Adding...")
        let data = AddNewContact(email: email)
        var request = URLRequest(url: Endpoint.createContact.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Auth.shared.getUserToken(), forHTTPHeaderField: "x-auth-token")
        request.httpBody = try! JSONEncoder().encode(data)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                Hud.networkErrorText(error: .networkMessage)
                completion(false, nil)
                return
            }
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(CreateContactResponse.self, from: safeData)
                        if let err = decodedData.error {
                        Hud.faildAndHide(withMessage: err)
                        completion(false, nil)
                    } else {
                        Hud.successAndHide()
                        completion(true, decodedData.id)
                    }
                    
                } catch {
                    Hud.networkErrorText(error: .networkMessage)
                }
            }
        }
        task.resume()
    }
    
    //====================================
    // Delete Contact
    //====================================
    struct deleteContactResponse: Codable {
        let error: String?
    }
    class func deleteContact(withID id: String, onView view: UIView, completion: @escaping(Bool) -> () ) {
        var request = URLRequest(url: Endpoint.deleteContact(id).url)
        let token = Auth.shared.getUserToken()
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        Hud.showLoadingHud(onView: view, withLabel: "Deleting...")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                Hud.networkErrorText(error: .networkMessage)
                completion(false)
                return
            }
            if let safeData = data {
                let decode = JSONDecoder()
                do {
                    let decodedData = try decode.decode(deleteContactResponse.self, from: safeData)
                    if let err = decodedData.error {
                        Hud.faildAndHide(withMessage: err)
                        completion(false)
                    } else {
                        Hud.successAndHide()
                        completion(true)
                    }
                } catch {
                    Hud.faildAndHide(withMessage: "Faild to delete contact")
                    completion(false)
                }
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
    
     //MARK:- Charity
    
    //====================================
    // Get Charity Initial data
    //====================================
    class func getCharityOrganizationInitialData(onView view: UIView, completion: @escaping([Charity], Error?)-> Void) {
        var request = URLRequest(url: Endpoint.charity.url)
        let token = Auth.shared.getUserToken()
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        request.httpMethod = "GET"
        Hud.showLoadingHud(onView: view)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                Hud.networkErrorText(error: .networkMessage)
                completion([], e)
                return
            }
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    var chs: [Charity] = []
                    let ch = try decoder.decode([CharityResponse].self, from: safeData)
                    ch.forEach {
                        chs.append(Charity(id: $0._id, name: $0.name, email: $0.email, link: $0.org_logo))
                    }
                    Hud.hide(after: 0.5)
                    completion(chs, nil)
                } catch {
                    Hud.networkErrorText(error: .decodeMessage)
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    //====================================
    // Get Charity Details
    //====================================
    /// ask server to get the static information about charity organization
    class func getCharityOrganizationDetails(withID id:String, onView view: UIView, completion: @escaping(CharityDetailsResponse?, Error?)-> Void) {
        Hud.showLoadingHud(onView: view)
        taskForGETRequest(url: Endpoint.charityDetails(id).url, response: CharityDetailsResponse.self) { (response, error) in
            if let details = response {
                completion(details, nil)
            }else {
                completion(nil, error)
            }
        }
        
    }
    
    //====================================
    // Get Charity Logo
    //====================================
    class func loadImageWithStrURL(str: String, completion: @escaping (UIImage?, Error?) -> () ) {
        let url = URL(string: str)!
        if let image = DNData.imageCache.object(forKey: str as AnyObject) {
            completion(image, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            if let safeData = data {
                if let image = UIImage(data: safeData) {
                    DNData.imageCache.setObject(image, forKey: str as AnyObject)
                    completion(image, nil)
                } else {
                    let error: Error = "faild unwrapping image"
                    completion(nil,  error)
                }
            }
        }
        task.resume()
    }
    
    
    
    //MARK:- Transaction
    
    class func transactionAmount(_ amount: Double, to email: String, completion: @escaping(Bool, Error?)->Void) {
        // code ...
    }
    
    
    
    /// ask API to return list contain from at most two items which is user's heirs
    class func getUserHeirs(onView view: UIView, completion: @escaping([Heirs], Error?) -> Void) {
        taskForGETRequest(url: Endpoint.heirs.url, response: [Heirs].self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion([], error)
            }
        }
    }
    

    
    
    
    /// convert currency_code to symbole if it founded
    class func symboleFromString(str: String) -> String {
        for currency in Currency.allCases {
            if currency.rawValue == str {
                return currency.symbole
            }
        }
        return "unknown"
    }
    /// Generic func preform get (fetch) request
    /// - Parameters:
    ///   - url: url which you ask server to fetch data from it.
    ///   - response: struct which confirm codable protocol.
    ///   - completion: closure func with return the codable struct object if the fetching process success and error otherwise.
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                Hud.networkErrorText(error: .networkMessage)
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                Hud.hide(after: 0.5)
                completion(responseObject, nil)
            } catch {
                Hud.networkErrorText(error: .decodeMessage)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func taskForGETRequestWithToken<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping(ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        let token = Auth.shared.getUserToken()
        request.setValue(token, forHTTPHeaderField: "x-auth-token")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                Hud.networkErrorText(error: .networkMessage)
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                Hud.hide(after: 0.5)
                completion(responseObject, nil)
            } catch {
                Hud.networkErrorText(error: .decodeMessage)
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
                Hud.networkErrorText(error: .networkMessage)
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                Hud.hide(after: 0.5)
                completion(responseObject, nil)
            } catch {
                Hud.networkErrorText(error: .decodeMessage)
                completion(nil, error)
            }
        }
        task.resume()
    }
}
