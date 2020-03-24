//
//  Auth.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import KeychainSwift
import LocalAuthentication

struct keys {
    static let keyPrefix = "dnwallet_"
    static let password = "password"
    static let email = "email"
}

/// Login, SignUp and get user's information from keychain
class Auth {
    
    static let shared = Auth()
    let keychain = KeychainSwift(keyPrefix: keys.keyPrefix)
    
    /// Login with Face ID or Touch ID
    func loginWithBiometric() {
        let context:LAContext = LAContext()
        var error: NSError?
        let reason = "Identify yourself"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics , error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                if success {
                    let password = self?.keychain.get(keys.password)
                    let email = self?.keychain.get(keys.email)
                    self?.authUserCredential(password, email: email)
                } else {
                    // some thing wrong
                }
            }
        } else {
            enableBiometricAuthAlert()
        }
    }
    
    
    /// Login with email and password
    /// - Parameters:
    ///   - password: user password which confirmed by API
    ///   - email: user id, it must be unique and also confirmed by API
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func authUserCredential(_ password: String?, email: String?) -> Bool {
        
        if let password = password, let email = email {
            print("password: \(password)\nemail: \(email)")
            // Login with API
            return true
        
        } else {
            // some thing wrong
            print("no user name or password")
            return false
        }
    }
    
    /// create new acount with user info
    /// - Parameters:
    ///   - user: user is a structure with (email - password - username - phone).
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func signUp(user: User) -> Bool {
        // add user info to database (API)
        
        // if success add the sensitive data to keychain
        keychain.set(user.email, forKey: keys.email, withAccess: .accessibleWhenUnlocked)
        keychain.set(user.password, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
        return true
        
        // else faild to create account return false, try again
        
    }
    
    /// update the user password from setting
    /// - Parameters:
    ///   - currentPassword: the current password entered to confirm the user.
    ///   - newPassword: new password.
    /// - Returns:
    ///   - Bool : return true of the process success, false otherwise.
    func updateCurrentPassword(_ currentPassword: String, newPassword: String) -> Bool {
        guard let password = keychain.get(keys.password) else { return false }
        if currentPassword ==  password{
            
            // first update the password in database (API)
            
            // if success then update password in keychain
            keychain.set(newPassword, forKey: keys.password, withAccess: .accessibleWhenUnlocked)
            
            // else faild to update password in the database, try again
            
        } else {
            // entered password not correct or faild to get the password from keychain
            return false
        }
        
        return true
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
    func enableBiometricAuthAlert() {
        let alert = UIAlertController(title: "Enable Biometric Auth", message: "Please enable your Face ID or Touch ID on your device", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        if let topVC = UIApplication.getTopMostViewController() {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension UIApplication {
    
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}
