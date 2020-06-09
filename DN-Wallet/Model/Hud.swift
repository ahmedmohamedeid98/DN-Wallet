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
    
    static func showLoadingHud(onView view: UIView) {
        currentView = view
        DispatchQueue.main.async {
            if stillNeedToshowLoading {
                currentHud = MBProgressHUD.showAdded(to: view, animated: true)
                currentHud?.label.text = hudError.loading.rawValue
            }
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
    static func networkErrorText(error: hudError) {
        // show errorMessage after indeterminedHud finish
        if let safeHud = currentHud  {
            currentHud = nil
            DispatchQueue.main.async {
                safeHud.mode = .text
                safeHud.isSquare = true
                safeHud.label.text = hudError.network.rawValue
                safeHud.detailsLabel.text = error.rawValue
                safeHud.hide(animated: true, afterDelay: 3)
            }
        }
        // show errorMessage even the indeterminedHud not shown
        else {
            stillNeedToshowLoading = false
            DispatchQueue.main.async {
                let newHud = MBProgressHUD.showAdded(to: currentView, animated: true)
                newHud.mode = .text
                newHud.isSquare = true
                newHud.label.text = hudError.network.rawValue
                newHud.detailsLabel.text = error.rawValue
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
