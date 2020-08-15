//
//  SceneDelegate.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 2/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var auth: UserAuthProtocol = UserAuth()
    //var remainingTime: Int64 = 0
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configureIQKeyboardManager()
        configureFirstLaunchCase(in: windowScene)
    }
    
    func configureIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldPlayInputClicks = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func configureFirstLaunchCase(in windowScene: UIWindowScene) {
        if !UserPreference.getBoolValue(withKey: UserPreference.firstLaunchKey) {
            // don't show guide screens again
            UserPreference.setValue(true, withKey: UserPreference.firstLaunchKey)
            auth.canEvaluatePolicyWithFaceID()
            window = UIWindow(windowScene: windowScene)
            // assign viewController
            let guideVC = ContainerViewController()
            window?.rootViewController = guideVC
            
            configureNavigationBar()
            // make it the first viewController appear in the window
            self.window?.makeKeyAndVisible()
        }
    }
    
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemGreen
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "SIDEMENUNOTIFICATIONS"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "CHECK_APP_OUT_SAFE_MODE"), object: nil)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

