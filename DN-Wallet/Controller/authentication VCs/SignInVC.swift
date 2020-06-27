//
//  SignInVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignInVC: UIViewController {

    @IBOutlet weak var emailCV: DNViewWithTextField!
    @IBOutlet weak var passwordCV: DNViewWithTextField!
    @IBOutlet weak var signInOutlet: UIButton!
    private var loginWithFaceIDButton = DNButton(backgroundColor: .DnColor, title: "   Login With FaceID", cornerRedii: 25.0, systemTitle: "faceid")
    private var FaceIdFounded: Bool = false
    private var TouchIdFounded: Bool = false
    private var LoginWithBiometric: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add both email & password textFiled
        initView()
        // add loginWithFaceIDButton & it's action
        // else login with TouchID else Login With (email & password)
        initAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailCV.textField.text = AuthManager.shared.getUserEmail()
        passwordCV.textField.text = ""
    }

    private func initAuth() {
    
        if checkIphoneBiometricMethod() {
            // login with faceid button's action
            loginWithFaceIDButton.withTarget = { [weak self] () in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    AuthManager.shared.loginWithBiometric(viewController: self, view: self.view)
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
            AuthManager.shared.loginWithBiometric(viewController: self, view: view)
            return false
        }
        // go and evaluate if the app support FaceID or Touch ID
        AuthManager.shared.canEvaluatePolicyWithFaceID()
        return false
    }
    
    private func initView() {
        signInOutlet.layer.cornerRadius = 20.0
        emailCV.configure(imageName: "envelope", placeholder: "Email", systemImage: true)
        passwordCV.configure(imageName: "lock", placeholder: "Password", systemImage: true, isSecure: true)
    }
    
    // if user have no account, this button will take him to a create account pages.
    @IBAction func haveNoAccountPressed(_ sender: Any) {
        let st = UIStoryboard(name: "Authentication", bundle: .main)
        let vc = st.instantiateViewController(identifier: "CreateAccountVCID") as? CreateAccountVC
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
//
////        //TEST TRST
////
    //    AuthManager.shared.pushHomeViewController(vc: self)
     //   return
////        // End TEST
        if emailCV.textField.text != "" && passwordCV.textField.text != "" {
            let email = emailCV.textField.text!
            let password = passwordCV.textField.text!
            if !AuthManager.shared.isValidEmail(email) {
                Hud.InvalidEmailText(onView: view)
                return
            }
            if password.count < 8 {
                Hud.InvalidPasswordText(onView: view)
                return
            }
            Hud.showLoadingHud(onView: view, withLabel: "Login...")
            AuthManager.shared.authWithUserCredential(credintial: Login(email: email, password: password)) { result in
                switch result {
                    case .success(_):
                        Hud.hide(after: 0.0)
                        AuthManager.shared.pushHomeViewController(vc: self)
                    case .failure(let err):
                        Hud.faildAndHide(withMessage: err.rawValue)
                }
            }
        }
    }
    // add loginWithFaceIDButton buttom to view, this method will fired if FaceID option exist.
    func setupLoginWithFaceIDLayout() {
        view.addSubview(loginWithFaceIDButton)
        loginWithFaceIDButton.DNLayoutConstraint(nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 40, bottom: 20, right: 50), size: CGSize(width: 0, height: 50))
    }
    
}
