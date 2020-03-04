//
//  startControllerForTest.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class startControllerForTest: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func login(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: .main)
        //let vc = storyboard.instantiateViewController(withIdentifier: "signInVCID") as? SignInVC
        let vc = storyboard.instantiateViewController(identifier: "signInVCID") as? SignInVC
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true)
    }
    
    @IBAction func signup(_ sender: Any) {
    }
}
