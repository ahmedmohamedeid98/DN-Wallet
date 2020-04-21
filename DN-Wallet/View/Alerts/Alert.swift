//
//  Alert.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/21/20.
//  Copyright © 2020 DN. All rights reserved.
//

class Alert {
    
    /// Alert to success situation show then disappear after time interval, don't wait for some task to compelete.
    class func syncSuccessfullWith(_ msg: String, dismissAfter time: TimeInterval = 1.0, viewController vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
        UIView.animate(withDuration: time) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    /// Alert to success situation show then disappear after time interval, wait for some task to compelete.
    class func asyncSuccessfullWith(_ msg: String, dismissAfter time: TimeInterval = 1.0, viewController vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            UIView.animate(withDuration: time) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    /// alert with ok action, don't wait another task to execute.
    class func syncActionOkWith(_ title: String?, msg: String?, viewController vc: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    /// alert with ok action, wait another task to execute.
    class func asyncActionOkWith(_ title: String?, msg: String?, viewController vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
