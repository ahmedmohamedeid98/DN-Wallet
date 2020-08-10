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
    private var auth: UserAuthProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add both email & password textFiled
        auth = UserAuth()
        initView()
        // add loginWithFaceIDButton & it's action
        // else login with TouchID else Login With (email & password)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailCV.textField.text = auth.getUSerEmail()
        passwordCV.textField.text = ""
        manageAuthentication()
    }

    private func manageAuthentication() {
    
        if checkIphoneBiometricMethod() {
            // login with faceid button's action
            loginWithFaceIDButton.withTarget = { [weak self] () in
                guard let self = self else { return }
                self.signInWithBiometric()
            }
        }
    }
    private func signInWithBiometric() {
        //Hud.showLoadingHud(onView: view, withLabel: "Login...")
            self.auth.signInWithBiometric { [weak self] (result) in
          //      Hud.hide(after: 0.0)
                guard let self = self else { return }
                switch result {
                    case .success(_):
                        self.navigateToHomeController()
                    case .failure(let err):
                        self.presentDNAlertOnTheMainThread(title: "Biometric Auth", Message: err.localizedDescription)
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
        TouchIdFounded = UserPreference.getBoolValue(withKey: UserPreference.biometricTypeTouchID)
        if TouchIdFounded {
            signInWithBiometric()
            return false
        }
        // go and evaluate if the app support FaceID or Touch ID
        auth.canEvaluatePolicyWithFaceID()
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

        guard let email = emailCV.textField.text, !email.isEmpty else {
            presentDNAlertOnTheMainThread(title: K.alert.faild , Message: ErrorMessage.emailRequired)
            return
        }
        
        guard email.isValidEmail else {
            presentDNAlertOnTheMainThread(title: K.alert.faild, Message: ErrorMessage.invaildEmail)
            return
        }
        
        guard let password = passwordCV.textField.text, !password.isEmpty else {
            presentDNAlertOnTheMainThread(title: K.alert.faild, Message: ErrorMessage.passwordRequired)
            return
        }
        guard password.count >= 8 else {
            presentDNAlertOnTheMainThread(title: K.alert.faild, Message: ErrorMessage.invaildPassword)
            return
        }

        Hud.showLoadingHud(onView: view, withLabel: "Login...")
        auth.signIn(data: Login(email: email, password: password)) { [weak self] (result) in
            Hud.hide(after: 0.0)
            guard let self = self else { return }
            switch result {
                case .success(_):
                    self.navigateToHomeController()
                case .failure(let err):
                    self.presentDNAlertOnTheMainThread(title: K.alert.faild, Message: err.localizedDescription)
            }
        }
}
    // add loginWithFaceIDButton buttom to view, this method will fired if FaceID option exist.
    func setupLoginWithFaceIDLayout() {
        view.addSubview(loginWithFaceIDButton)
        loginWithFaceIDButton.DNLayoutConstraint(nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 40, bottom: 20, right: 50), size: CGSize(width: 0, height: 50))
    }
    
    private func navigateToHomeController() {
        DispatchQueue.main.async {
            let containerVC = ContainerVC()
            containerVC.modalPresentationStyle = .fullScreen
            self.present(containerVC, animated: true, completion: nil)
        }
    }
    
}
