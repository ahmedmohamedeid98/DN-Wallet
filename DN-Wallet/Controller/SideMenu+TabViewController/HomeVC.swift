//
//  HomeVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

protocol HomeViewControllerDelegate: class {
    func handleSideMenuToggle()
}

class HomeVC: UIViewController {

    //MARK:- Properities
    var isExpand: Bool = false
    var leftBarButton: UIBarButtonItem!
    weak var delegate:HomeViewControllerDelegate?
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handleNavigationBar()
        addGestureRecognizer()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Handlers
    func handleNavigationBar() {
        let titleColor = UIColor.white
        let backgroundColor = UIColor.DN.DarkBlue.color()
        self.configureNavigationBar(largeTitleColor: titleColor, backgoundColor: backgroundColor, tintColor: titleColor, title: "Home", preferredLargeTitle: false)
        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideMenuButtonPressed))
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeSideMenuWithGesture))
        let rightSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(sideMenuButtonPressed))
        let leftSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeSideMenuWithGesture))
        leftSwipGesture.direction = .left
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(rightSwipGesture)
        view.addGestureRecognizer(leftSwipGesture)
    }
    
    @objc func sideMenuButtonPressed() {
        delegate?.handleSideMenuToggle()
        isExpand = !isExpand
    }
    @objc func closeSideMenuWithGesture() {
        if isExpand {
            delegate?.handleSideMenuToggle()
            isExpand = !isExpand
        }
    }
}
