//
//  UIViewController+Ext.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/23/20.
//  Copyright © 2020 DN. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func configureNavigationBar(_ titleTintColor : UIColor = .white, backgoundColor: UIColor = .DnColor, tintColor: UIColor = .white, title: String, preferredLargeTitle: Bool = false) {
    if #available(iOS 13.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: titleTintColor]
        appearance.titleTextAttributes = [.foregroundColor: titleTintColor]
        appearance.backgroundColor = backgoundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = tintColor
        navigationItem.title = title

    } else {
        // Fallback on earlier versions
        navigationController?.navigationBar.barTintColor = backgoundColor
        navigationController?.navigationBar.backgroundColor = backgoundColor
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = tintColor
        navigationItem.title = title
    }
}
    
    func presentPopUpMenu(withCategory data: PopUpMenuDataSource, to vc: PopUpMenuDelegate) {
        let viewController = PopUpMenu()
        viewController.menuDelegate = vc
        viewController.dataSource = data
        let NavigationControllerPopUpMenu = UINavigationController(rootViewController: viewController)
        self.present(NavigationControllerPopUpMenu, animated: true, completion: nil)
    }
    
    func presentDNAlertOnTheMainThread(title: String?, Message msg: String, buttonTitle: String = "OK") {
        DispatchQueue.main.async {
            let alert = DNAlertVC(title: title ?? "", message: msg, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle   = .crossDissolve
            self.present(alert, animated: true)
        }
    }
    func presentDNAlertOnForground(title: String?, Message msg: String, buttonTitle: String = "OK") {
        let alert = DNAlertVC(title: title ?? "", message: msg, buttonTitle: buttonTitle)
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle   = .crossDissolve
        self.present(alert, animated: true)
    }
    func showEmptyStateView(withMessage message: String, completion: @escaping(UIView) -> ()) {
        DispatchQueue.main.async {
            let emptyStateView      = DNEmptyStateView(message: message)
            emptyStateView.frame    = self.view.bounds
            self.view.addSubview(emptyStateView)
            completion(emptyStateView)
        }
    }
    
}
