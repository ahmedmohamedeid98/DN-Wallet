//
//  EditProfileVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/6/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class PrivacyVC: PrivacyTermsVC {

    // in future this data will come from API
    let data: [PrivacySection] = [
        PrivacySection(title: "Camera",
                       description: "Privacy is a fundamental human right. At DN-Wallet, it’s also one of our core values. so we ask you to allow us access camer to scan other user's qrcode which necessary to complete transaction process, in addition to these information does not sotred in any database"),
        PrivacySection(title: "Login With Touch/Face ID",
                       description: "interdum id porta nec, ullamcorper eu nulla. Vivamus aliquet faucibus odio, quis tristique risus varius eu. Donec tincidunt nibh sit amet elit gravid, at condimentum metus gravida. Donec sed venenatis felis, nec congue felis.Praesent ac quam volutpat, ullamcorper ipsum."),
        PrivacySection(title: "Location",
                       description: "Praesent ac quam volutpat, ullamcorper ipsum vitae, cursus dui. Proin euismod elementum arcu quis interdum. Donec euismod rhoncus magna et sollicitudin. Nunc nisl augue, interdum id porta nec, ullamcorper eu nulla. Vivamus aliquet faucibus odio, quis tristique risus varius eu. Donec tincidunt nibh sit amet elit gravida, at condimentum metus gravida. Donec sed venenatis felis, nec congue felis.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        self.items = data
    }
}

