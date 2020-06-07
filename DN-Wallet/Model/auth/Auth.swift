//
//  Auth.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import KeychainSwift
import LocalAuthentication


// MARK:- Setup Keychain keys
// keychain keys
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

// MARK:- Setup Authentication calss

/// Login, SignUp and get user's information from keychain
class Auth {
    
    static let shared = Auth()
    let keychain = KeychainSwift(keyPrefix: keys.keyPrefix)
    
    /// check iphone's boimetric typr
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
    
    /// Login with Face ID or Touch ID
    func loginWithBiometric(viewController vc: UIViewController) {
        let reason = "Identify yourself"
        let context:LAContext = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics , error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                if success {
                    guard let password = self?.keychain.get(keys.password) else { return }
                    guard let email = self?.keychain.get(keys.email) else { return }
                    self?.authWithUserCredential(credintial: Login(email: email, password: password)) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self?.pushHomeViewController(vc: vc)
                            }
                        
                        }else {
                            Alert.asyncActionOkWith("Faild Login", msg: "Something was wrong, try again.", viewController: vc)
                        }
                    }
                } else {
                    // faild to identify user: automatically handled
                }
            }
            
        }else {
            // ask user to enrolled his local authentication (enroll faceid or touch id)
           DispatchQueue.main.async {
                Auth.shared.enableBiometricAuthAlert(viewController: vc)
            }
        }
    }
    
    /// Login with email and password
    /// - Parameters:
    ///   - password: user password which confirmed by API
    ///   - email: user id, it must be unique and also confirmed by API
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func authWithUserCredential(credintial: Login, completion: @escaping (Bool, Error?)->Void) {
        let data = Login(email: credintial.email,
                         password: credintial.password)
        DNData.login(credintial: data) { (response, error) in
            if let e = error {
                completion(false, e)
            } else {
                if let safeResponse = response {
                    self.keychain.set(data.email, forKey: keys.email)
                    self.keychain.set(data.password, forKey: keys.password)
                    self.keychain.set(safeResponse.token, forKey: keys.token)
                    completion(true, nil)
                }
            }
        }
    }
    
    /// create new acount with user info
    /// - Parameters:
    ///   - user: user is a structure with (email - password - username - phone - ...).
    func createAccount(user: User, completion: @escaping(Bool, Error?)-> Void) {
        let data = Register(name: user.username,
                            email: user.email,
                            password: user.password,
                            confirm_password: user.password,
                            phone: user.phone,
                            country: user.country)
        DNData.register(with: data) { [weak self] (response, error) in
            guard let self = self else { return }
            if let response = response {
                self.keychain.set(user.email, forKey: keys.email, withAccess: .accessibleWhenUnlocked)
                self.keychain.set(user.password, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
                self.keychain.set(response.id, forKey: keys.id, withAccess: .accessibleWhenUnlocked)
                self.keychain.set(response.token, forKey: keys.token, withAccess: .accessibleWhenUnlocked)
                completion(true, nil)
            }else {
                completion(false, error)
            }
        }
    }
    func logout() {
        // delete token
        keychain.set("", forKey: keys.token)
    }
    func getUserToken() -> String? {
        return keychain.get(keys.token)
    }
    /// update the user password from setting
    /// - Parameters:
    ///   - currentPassword: the current password entered to confirm the user.
    ///   - newPassword: new password.
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func updateCurrentPassword(newPassword: String, compiletion: @escaping (Bool, Error?) -> () ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            compiletion(false, nil)
        }
    }
    
    func validateCurrentPassword(currentPassword: String) -> Bool {
        guard let password = keychain.get(keys.password) else { return false }
        if currentPassword ==  password {
            return true
        } else {
            return false
        }
    }
    
    /// update the user password when he forget it.
    /// - Parameters:
    ///   - newPassword: send new password to the database.
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func updateWithNewPassword(_ newPassword: String) -> Bool {
        
        // first update in database (API)
        
        // if success then update password in keychain
        keychain.set(newPassword, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
        
        // else return false, faild to update the password
        return true
        // update password in both keychain & database
    }

    
    /// forget the current password and go to change it, confirm user email
    /// - Parameters:
    ///   - email: user email which the confirmation code will sent to it.
    func forgetCurrentPassword(_ email: String) {
        // sent confirmation digits to the user email
    }
    
    /// compare the two confirmation code equality.
    /// - Parameters:
    ///   - userDigits: the digits enter by user in the opt.
    ///   - sendDigits: the random digits that send by the app.
    /// - Returns:
    ///   - Bool : return true if the both are the same, false otherwise.
    func compareConfirmationDigits(_ userDigits: String, sendDigits: String) -> Bool {
        return userDigits == sendDigits
    }
    
    func generateConfirmationCode() -> String {
         var code = ""
         repeat {
             // Create a string with a random number 0...9999
             code = String(format:"%04d", arc4random_uniform(10000) )
         } while Set<Character>(code).count < 4
         return code
    }
    
    /// Alert pop up when the user do not enable his biometric authentication
    func enableBiometricAuthAlert(viewController: UIViewController) {
        let title = "Enable Biometric Auth"
        let message = "Please enable your Face/Touch ID on your device"
        buildAndPresentAlertWith(title, message: message, viewController: viewController)
    }
    
    func getUserEmail() -> String? {
        return keychain.get(keys.email)
    }
    
    func getNeededDataToQRCode() -> String {
        guard let data = keychain.get(keys.email) else {return "unknown user"}
        return data
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
    func faildLoginAlert(viewController: UIViewController) {
        let title = "Faild Login"
        let message = "Email/Password is Invalid."
        buildAndPresentAlertWith(title, message: message, viewController: viewController)
    }
    
    func buildAndPresentAlertWith(_ title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func pushHomeViewController(vc: UIViewController) {
        let containerVC = ContainerVC()
        containerVC.modalPresentationStyle = .fullScreen
        vc.present(containerVC, animated: true, completion: nil)
    }
    
}
 //MARK:- Safe Mode Methods
extension Auth {
    // check if the app in safe mode or not
    var isAppInSafeMode: Bool {
        get {
            return keychain.getBool(keys.safeModeActive) ?? false
        }
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
    }
    // decrease allowed amount when user pay something
    func updateAllowedAmoundInSafeMode(with newAmount: Int) {
        keychain.set("\(newAmount)", forKey: keys.allowedAmount)
    }
    
    func checkIfAppOutTheSafeMode(compeletion: @escaping(Int64, Error?) -> Void) {
        //DNData.taskForGETRequest(url: <#T##URL#>, response: <#T##Decodable.Protocol#>, completion: <#T##(Decodable?, Error?) -> Void#>)
    }
    
}
