//
//  UserAuth.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/3/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation
import KeychainSwift
import LocalAuthentication

protocol UserAuthProtocol { //this for make code testable
    func signIn(data: Login, completion: @escaping(Result<Bool, NSError>) -> ())
    func signUp(data: Register, completion: @escaping(Result<Bool, NSError>) -> ())
    func signInWithBiometric(completion: @escaping(Result<Bool, NSError>)-> ())
    func canEvaluatePolicyWithFaceID()
    func signOut()
    func getUserToken() -> String?
    func getUSerEmail() -> String?
    func validate(currentPassword pass: String) -> Bool
    
    func setSafeModeTime(hours: String)
    func getSafeModeTime() -> String
    func activeSafeMode()
    func deactiveSafeMode()
    var isAppInSafeMode: Bool { get }
    var allowedAmountInSafeMode: Double { get set }
}

class UserAuth: BaseAPI<UserAuthNetworking>, UserAuthProtocol {
    
    private let keychain = KeychainSwift(keyPrefix: keys.keyPrefix)
    
    func signIn(data: Login, completion: @escaping(Result<Bool , NSError>) -> ()) {
        self.APIRequest(target: .login(data: data), responseClass: LoginResponse.self) { result in
            switch result {
                case .success(let response):
                    self.keychain.set(data.email, forKey: keys.email)
                    self.keychain.set(data.password, forKey: keys.password)
                    self.keychain.set(response.token, forKey: keys.token)
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func signUp(data: Register, completion: @escaping(Result<Bool, NSError>) -> ()) {
        self.APIRequest(target: .register(data: data), responseClass: RegisterResponder.self) { result in
            switch result {
                case .success(let response):
                    self.keychain.set(data.email, forKey: keys.email)
                    self.keychain.set(data.password, forKey: keys.password)
                    self.keychain.set(response.token, forKey: keys.token)
                    self.keychain.set(response.id, forKey: keys.id)
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func signInWithBiometric(completion: @escaping(Result<Bool, NSError>)-> ()) {
        let reason = "Identify yourself"
        let context: LAContext = LAContext()
        let policy: LAPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        var error: NSError?
        
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: reason) { [weak self] (done, err) in
                guard let self = self else { return }
                if done {
                    guard let passCode  = self.keychain.get(keys.password) else { return }
                    guard let email     = self.keychain.get(keys.email) else { return }
                    self.signIn(data: Login(email: email, password: passCode), completion: completion)
                }
            }
        } else {
            let error = NSError(domain: "base/url", code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.invalidBiometrics])
            completion(.failure(error))
        }
    }
    
    func canEvaluatePolicyWithFaceID() {
        let context:LAContext = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics , error: &error) {
            switch context.biometryType {
            case .none:
                break
            case .touchID:
                UserPreference.setValue(true, withKey: UserPreference.biometricTypeTouchID)
            case .faceID:
                UserPreference.setValue(true, withKey: UserPreference.biometricTypeFaceID)
            @unknown default:
                break
            }
        }
    }
    
    func signOut() {
        self.keychain.set("", forKey: keys.token)
    }
    
    func getUserToken() -> String? {
        return keychain.get(keys.token)
    }
    
    func getUSerEmail() -> String? {
        return keychain.get(keys.email)
    }
    
    func validate(currentPassword pass: String) -> Bool {
        if let correctPassword = keychain.get(keys.password) {
            return correctPassword == pass
        }
        return false
    }
    
    //=========================
    // SafeMode
    //=========================
    
    
    // check if the app in safe mode or not
    var isAppInSafeMode: Bool {
        get {
            return keychain.getBool(keys.safeModeActive) ?? false
        }
    }
    func setSafeModeTime(hours: String = "12") {
        keychain.set(hours, forKey: keys.safeModeTime)
    }
    
    func getSafeModeTime() -> String {
        if let safeData = keychain.get(keys.safeModeTime) {
            return safeData
        }
        return "0"
    }
    // active safe mode "we can do this in the app setting"
    func activeSafeMode() {
        keychain.set(true, forKey: keys.safeModeActive)
    }
    // deactive safe mode "this may during app Luanch"
    // or if the remaining time less than 3 h try after that time
    func deactiveSafeMode() {
        keychain.set(false, forKey: keys.safeModeActive)
    }
    // this is properity which contain the limited amount that user can deal with it (Pay) during safe mode
    var allowedAmountInSafeMode: Double {
        get {
            return Double(keychain.get(keys.allowedAmount) ?? "0") ?? 0.0
        }
        set {
            keychain.set(String(newValue), forKey: keys.allowedAmount)
        }
    }
    
    // active safe mode
    // reload side menu table
    // caculate the current time
    // add a deta time (safe mode time to it)
    // store new time to keychain
    // check if the current time greater that the safed time of not
    // if it is greater deactive save mode else
    func checkIfAppOutTheSafeMode(compeletion: @escaping(Int64, Error?) -> Void) {
        //DNData.taskForGETRequest(url: <#T##URL#>, response: <#T##Decodable.Protocol#>, completion: <#T##(Decodable?, Error?) -> Void#>)
    }
}
//=======================
// keys used in keychain
//=======================

struct keys {
    static let keyPrefix = "dnwallet_"
    static let id = "user_id"
    static let password = "password"
    static let email = "email"
    static let token = "user_token"
    static let safeModeTime = "safe_mode_time"
    static let safeModeActive = "safe-mode-active"
    static let qrCodeFileName = "DN-QRCode-Image.png"
    static let allowedAmount = "allowed-amount"
}


