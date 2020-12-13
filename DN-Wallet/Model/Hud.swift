//
//  Hud.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
import MBProgressHUD

class Hud {
    
    private static var stillNeedToshowLoading: Bool = true
    private static var currentHud: MBProgressHUD?
    private static var currentView: UIView!
    
    enum hudError : String {
        case decodeMessage = "faild to decode data coming from server"
        case networkMessage = "Please check your internet connnection and try again later"
        case invalidMail = "invalid mail. try again"
        case invalidPassword = "invalid password. try again"
        case loading = "Loading..."
        case network = "Network Error"
    }
    
    static func InvalidEmailText(onView view: UIView, hidAfter delay: TimeInterval = 3) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        textOnly(hudError.invalidMail.rawValue, onHud: hud, delay: delay)
    }
    static func InvalidPasswordText(onView view: UIView, hidAfter delay: TimeInterval = 3) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        textOnly(hudError.invalidPassword.rawValue, onHud: hud, delay: delay)
    }
    
    static func showLoadingHud(onView view: UIView, withLabel msg: String = "Loading...") {
        currentView = view
        DispatchQueue.main.async {
            if stillNeedToshowLoading {
                currentHud = MBProgressHUD.showAdded(to: view, animated: true)
                currentHud?.label.text = msg
            }
        }
    }
    static func successAndHide(withMessage msg: String = "Success") {
        if let safeHud = currentHud {
            currentHud = nil
            DispatchQueue.main.async {
                safeHud.mode = .customView
                let img = UIImageView(image: UIImage(systemName: "checkmark"))
                img.tintColor = .label
                safeHud.customView = img
                safeHud.customView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                safeHud.label.text = msg
                safeHud.hide(animated: true, afterDelay: 2)
            }
        } else {
            stillNeedToshowLoading = false
        }
    }
    
    static func faildAndHide(withMessage msg: String = "faild") {
        if let safeHud = currentHud {
            currentHud = nil
            DispatchQueue.main.async {
                safeHud.mode = .customView
                let img = UIImageView(image: UIImage(systemName: "xmark"))
                img.tintColor = .label
                safeHud.customView = img
                safeHud.customView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                safeHud.label.text = msg
                safeHud.hide(animated: true, afterDelay: 3)
            }
        } else {
            stillNeedToshowLoading = false
        }
    }
    static func hide(after seconds: TimeInterval) {
        guard let safeHud = currentHud else {
            stillNeedToshowLoading = false
            return
        }
        DispatchQueue.main.async {
            safeHud.hide(animated: true, afterDelay: seconds)
        }
        currentHud = nil
    }
    static func networkErrorText(error: String) {
        // show errorMessage after indeterminedHud finish
        if let safeHud = currentHud  {
            currentHud = nil
            DispatchQueue.main.async {
                safeHud.mode = .text
                safeHud.label.text = "failed"
                safeHud.detailsLabel.text = error
                safeHud.hide(animated: true, afterDelay: 3)
            }
        }
        // show errorMessage even the indeterminedHud not shown
        else {
            stillNeedToshowLoading = false
            DispatchQueue.main.async {
                let newHud = MBProgressHUD.showAdded(to: currentView, animated: true)
                newHud.mode = .text
                newHud.label.text = "faild"
                newHud.detailsLabel.text = error
                newHud.hide(animated: true, afterDelay: 3)
            }
        }
        
    }
    
    
    
    
    //MARK:- assets methods
    private static func textOnly(_ message: String, onHud hud: MBProgressHUD, delay: TimeInterval) {
        hud.mode = .text
        hud.label.text = message
        hud.hide(animated: true, afterDelay: delay)
    }
}
