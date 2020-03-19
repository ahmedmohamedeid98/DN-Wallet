//
//  DonationDetailsVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DonationDetailsVC: UIViewController {

    // status bar background
    var statusBar: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.DN.DarkBlue.color()
        return vw
    }()
    
    // navigation bar contain dismiss button - and organization title
    var navBar: UIView = {
        let vw = UIView()
        vw.backgroundColor = .black
        vw.alpha = 0.2
        return vw
    }()
    
    // organization image
    var orgBackgroundImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "test1")
        return img
    }()
    
    // view controller title which will be organization title
    var orgTitle : UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.text = "Organization Name"
        lb.font = UIFont.DN.Regular.font(size: 18)
        return lb
    }()
    
    // back button dismiss the view controller
    var backButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    var address : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Address"
        view.detailsView.text = "Zeinhom, El-Sayeda Zainab, Cairp Governorate"
        return view
    }()
    var founder : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Founders"
        view.detailsView.text = "Ola Ghabour, Sjerif Abouel Naga, Fakery Abdel Hamid, Somaya Abouelenein, Sohair Farghaly"
        return view
    }()
    var mobile : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Mobile"
        view.detailsView.text = "19057"
        return view
    }()
    var about : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "About"
        view.detailsView.text = "57357 Hospital, located in Cairo, Egypt, is a hospital specializing in children's cancer.[citation needed] Fundraising for the hospital, including well-attended benefit festivals, started in 1998, with a target date for opening of December 2003.[1] It eventually opened in 2007.[2]"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupLayout()
    }
    // convert the status bar color from black to white
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupNavBar() {
        view.addSubview(statusBar)
        navBar.addSubview(backButton)
        navBar.addSubview(orgTitle)
        statusBar.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 20))
        orgTitle.DNLayoutConstraint(centerH: true, centerV: true)
        backButton.DNLayoutConstraint(left: navBar.leftAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 30, height: 30), centerV: true)
    }
    
    func setupLayout() {
        view.addSubview(orgBackgroundImage)
        orgBackgroundImage.addSubview(navBar)
        orgBackgroundImage.DNLayoutConstraint(statusBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 200))
        navBar.DNLayoutConstraint(orgBackgroundImage.topAnchor, left: orgBackgroundImage.leftAnchor, right: orgBackgroundImage.rightAnchor, size: CGSize(width: 0, height: 50))
        let Vstack = UIStackView(arrangedSubviews: [address, founder, mobile, about])
        view.addSubview(Vstack)
        address.DNLayoutConstraint(size: CGSize(width: 0, height: 40))
        founder.DNLayoutConstraint(size: CGSize(width: 0, height: 80))
        mobile.DNLayoutConstraint(size: CGSize(width: 0, height: 40))
        Vstack.axis = .vertical
        Vstack.backgroundColor = .red
        Vstack.distribution = .fillProportionally
        Vstack.alignment = .fill
        Vstack.spacing = 8
        Vstack.DNLayoutConstraint(orgBackgroundImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
        
        
    }

}
