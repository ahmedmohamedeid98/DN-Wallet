//
//  SignInVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailCV: userInput!
    @IBOutlet weak var passwordCV: userInput!
    @IBOutlet weak var signInOutlet: UIButton!
    var loginWithFaceIDButton = SAButton(backgroundColor: .DnColor, title: "   Login With FaceID", systemTitle: "faceid")
    var FaceIdFounded: Bool = false
    var TouchIdFounded: Bool = false
    var LoginWithBiometric: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        // add both email & password textFiled
        initView()
        // add loginWithFaceIDButton & it's action
        // else login with TouchID else Login With (email & password)
        initAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailCV.textField.text = Auth.shared.getUserEmail()
        passwordCV.textField.text = ""
    }

    private func initAuth() {
    
        if checkIphoneBiometricMethod() {
            // login with faceid button's action
            loginWithFaceIDButton.withTarget = { [weak self] () in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    Auth.shared.loginWithBiometric(viewController: self)
                }
            }
        }
    }
    
    private func checkIphoneBiometricMethod() -> Bool {
        // if user accept login with Biometric
        LoginWithBiometric = UserPreference.getBoolValue(withKey: UserPreference.loginWithBiometric)
        if !LoginWithBiometric {
            return false
        }
        // if iphone support FaceID, add it's button
        FaceIdFounded = UserPreference.getBoolValue(withKey: UserPreference.biometricTypeFaceID)
        if  FaceIdFounded {
            setupLoginWithFaceIDLayout()
            return true
        }
        // if no FaceID then try login with touchID
        TouchIdFounded = UserPreference.getBoolValue(withKey: UserPreference.biometricTypeFaceID)
        if TouchIdFounded {
            Auth.shared.loginWithBiometric(viewController: self)
            return false
        }
        // go and evaluate if the app support FaceID or Touch ID
        Auth.shared.canEvaluatePolicyWithFaceID()
        return false
    }
    
    private func initView() {
        signInOutlet.layer.cornerRadius = 20.0
        emailCV.configureInputField(imageName: "envelope", systemImage: true, placeholder: "Email", isSecure: false)
        passwordCV.configureInputField(imageName: "lock", systemImage: true, placeholder: "Password", isSecure: true)
    }
    
    // if user have no account, this button will take him to a create account pages.
    @IBAction func haveNoAccountPressed(_ sender: Any) {
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "signUpVCID") as? SignUpVC
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    // if user forget password this button will take him to reset password pages.
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        let forgetPassVC = FPEnterEmailVC()
        //forgetPassVC.modalPresentationStyle = .fullScreen
        self.present(forgetPassVC, animated: true, completion: nil)
    }
    // if user enter his (email & password) and pressed signIn
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        //TEST TRST
        
        Auth.shared.pushHomeViewController(vc: self)
        return
        // End TEST
        if emailCV.textField.text != "" && passwordCV.textField.text != "" {
            let email = emailCV.textField.text!
            let password = passwordCV.textField.text!
            if !Auth.shared.isValidEmail(email) {
                Alert.syncActionOkWith(nil, msg: K.auth.emailNotvalid, viewController: self)
                return
            }
            if password.count < 8 {
                Alert.syncActionOkWith(nil, msg: K.auth.passwordNotValid, viewController: self)
                return
            }
            
            Auth.shared.authWithUserCredential(credintial: Login(email: email, password: password)) { (success, error) in
                if success {
                    Auth.shared.pushHomeViewController(vc: self)
                } else {
                    Alert.asyncActionOkWith(nil, msg: K.auth.invalidEmailOrPass, viewController: self)
                }
            }
        }
    }
    // add loginWithFaceIDButton buttom to view, this method will fired if FaceID option exist.
    func setupLoginWithFaceIDLayout() {
        view.addSubview(loginWithFaceIDButton)
        let loginWithFaceIdHeight: CGFloat = 50
        loginWithFaceIDButton.DNLayoutConstraint(nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 40, bottom: 20, right: loginWithFaceIdHeight), size: CGSize(width: 0, height: 50))
        loginWithFaceIDButton.setCornerRadiusWithHeight = loginWithFaceIdHeight
    }
    
}
