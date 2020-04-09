//
//  ContainerVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

class ContainerVC: UIViewController {
    
    //MARK:- Properities
    var sideMenuController: SideMenuVC!
    var centerTabBarController: UITabBarController!
    var isExpand: Bool = false
    var NavHomeViewController: UINavigationController!
    var NavPayViewController: UINavigationController!
    var NavSaleViewController: UINavigationController!
    var NavChargeViewController: UINavigationController!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        handleHomeViewController()
    }
    
    //MARK:- Handlers
    func handleHomeViewController() {
        EmbededViewControllersInNavigationController()
        centerTabBarController = UITabBarController()
        centerTabBarController.viewControllers = [NavHomeViewController, NavPayViewController, NavSaleViewController, NavChargeViewController]
        centerTabBarController.selectedViewController = NavHomeViewController
        view.addSubview(centerTabBarController.view)
        addChild(centerTabBarController)
        centerTabBarController.didMove(toParent: self)
    }
    
    fileprivate func EmbededViewControllersInNavigationController() {
        let st = UIStoryboard(name: "Main", bundle: .main)
        let homeViewController = HomeVC()
        homeViewController.delegate = self
        configureTabBarItems(vc: homeViewController, title: "Home", image: "house")
        NavHomeViewController = UINavigationController(rootViewController: homeViewController)
        let payVC = st.instantiateViewController(withIdentifier: "PayVC") as! PayVC
        configureTabBarItems(vc: payVC, title: "Pay", image: "qrcode.viewfinder")
        NavPayViewController = UINavigationController(rootViewController: payVC)
        let saleVC = st.instantiateViewController(withIdentifier: "SaleVC") as! SaleVC
        configureTabBarItems(vc: saleVC, title: "Sale", image: "qrcode")
        NavSaleViewController = UINavigationController(rootViewController: saleVC)
        let chargeVC = st.instantiateViewController(withIdentifier: "ChargeVC") as! ChargeVC
        configureTabBarItems(vc: chargeVC, title: "Charge", image: "battery.25")
        NavChargeViewController = UINavigationController(rootViewController: chargeVC)
    }
    
    func configureTabBarItems(vc: UIViewController, title: String, image: String) {
            let item = UITabBarItem()
            item.title = title
            item.image = UIImage(systemName: image)
            vc.tabBarItem = item
    }
    
    func handleSideMenuViewController() {
        if sideMenuController == nil {
            sideMenuController = SideMenuVC()
            view.insertSubview(sideMenuController.view, at: 0)
            addChild(sideMenuController)
            sideMenuController.didMove(toParent: self)
        }
    }
    
    func showMenu(shouldExpand: Bool) {
        if shouldExpand {
            // show side menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerTabBarController.view.frame.origin.x = self.centerTabBarController.view.frame.width - 80
            }, completion: nil)
        } else {
            // hide side menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerTabBarController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
    
}

extension ContainerVC: HomeViewControllerDelegate {
    func handleSideMenuToggle() {
        if !isExpand {
            handleSideMenuViewController()
        }
        isExpand = !isExpand
        showMenu(shouldExpand: isExpand)
        
    }
    
}
