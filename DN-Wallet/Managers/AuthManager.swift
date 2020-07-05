//
//  Auth.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/23/20.
//  Copyright © 2020 DN. All rights reserved.
//
/*
import KeychainSwift
import LocalAuthentication
import MBProgressHUD
// MARK:- Setup Keychain keys
// keychain keys


// MARK:- Setup Authentication calss

/// Login, SignUp and get user's information from keychain
final class AuthManager {
}
   
 
    static let shared = AuthManager()
    private let keychain = KeychainSwift(keyPrefix: keys.keyPrefix)
    private init() {}
     //MARK:- Boimetric Existence
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
     //MARK:- Login With FaceID
    /// Login with Face ID or Touch ID
    func loginWithBiometric(viewController vc: UIViewController, view: UIView) {
        let reason = "Identify yourself"
        let context:LAContext = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics , error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                if success {
                    guard let password = self?.keychain.get(keys.password) else { return }
                    guard let email = self?.keychain.get(keys.email) else { return }
                    Hud.showLoadingHud(onView: view, withLabel: "Login...")
                    self?.authWithUserCredential(credintial: Login(email: email, password: password)) { result in
                        switch result {
                            case .success(_):
                                Hud.hide(after: 0.0)
                                self?.pushHomeViewController(vc: vc)
                            case .failure(let err):
                                Hud.faildAndHide(withMessage: err.rawValue)
                        }
                    }
                }
            }
            
        }else {
            // ask user to enrolled his local authentication (enroll faceid or touch id)
           DispatchQueue.main.async {
                AuthManager.shared.enableBiometricAuthAlert(viewController: vc)
            }
        }
    }
    
     //MARK:- Login with email & password
    /// Login with email and password
    /// - Parameters:
    ///   - password: user password which confirmed by API
    ///   - email: user id, it must be unique and also confirmed by API
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func authWithUserCredential(credintial: Login, completion: @escaping (Result<Bool, DNError>)->Void) {
        let data = Login(email: credintial.email, password: credintial.password)
        NetworkManager.login(credintial: data) { result in
            switch result {
                case .success(let LoginResponse):
                    self.keychain.set(data.email, forKey: keys.email)
                    self.keychain.set(data.password, forKey: keys.password)
                    self.keychain.set(LoginResponse.token, forKey: keys.token)
                    completion(.success(true))
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
     //MARK:- Create Account
    /// create new acount with user info
    /// - Parameters:
    ///   - user: user is a structure with (email - password - username - phone - ...).
    func createAccount(data: Register, completion: @escaping(Result<Bool, DNError>)-> Void) {
        NetworkManager.register(with: data) { result in
            switch result {
                case .success(let registerResponse):
                    self.keychain.set(data.email, forKey: keys.email, withAccess: .accessibleWhenUnlocked)
                    self.keychain.set(data.password, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
                    self.keychain.set(registerResponse.id, forKey: keys.id, withAccess: .accessibleWhenUnlocked)
                    self.keychain.set(registerResponse.token, forKey: keys.token, withAccess: .accessibleWhenUnlocked)
                    completion(.success(true))
                case .failure(let err):
                    completion(.failure(err))
            }
        }
    }
     //MARK:- Logout
    func logout() {
        // delete token
        keychain.set("", forKey: keys.token)
    }
    
    //MARK:- Get Token
    func getUserToken() -> String? {
        return keychain.get(keys.token)
    }
    
     //MARK:- Update Password
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
        DispatchQueue.main.async {
            let containerVC = ContainerVC()
            containerVC.modalPresentationStyle = .fullScreen
            vc.present(containerVC, animated: true, completion: nil)
        }
    }
    
}
 //MARK:- Safe Mode Methods
extension AuthManager {
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
    }
    // decrease allowed amount when user pay something
    func updateAllowedAmoundInSafeMode(with newAmount: Int) {
        keychain.set("\(newAmount)", forKey: keys.allowedAmount)
    }
    
    func checkIfAppOutTheSafeMode(compeletion: @escaping(Int64, Error?) -> Void) {
        //DNData.taskForGETRequest(url: <#T##URL#>, response: <#T##Decodable.Protocol#>, completion: <#T##(Decodable?, Error?) -> Void#>)
    }
    
}
*/
