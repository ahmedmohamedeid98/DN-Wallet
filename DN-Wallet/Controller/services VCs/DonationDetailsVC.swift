//
//  DonationDetailsVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
import MapKit

class DonationDetailsVC: UIViewController {

    
    var org : CharityOrg!
    //var org = CharityOrg(Id: 0,name:"57357 Hospital", email: "57357@gmail.com", logo: UIImage(), image: UIImage(), title: "57357 Hospital", location_lat: 30.022715, location_log: 31.237870, address: "Zeinhom, El-Sayeda Zainab, Cairp Governorate" , contactUs: "19057" , about: "57357 Hospital, located in Cairo, Egypt, is a hospital specializing in children's cancer.[citation needed] Fundraising for the hospital, including well-attended benefit festivals, started in 1998, with a target date for opening of December 2003.[1] It eventually opened in 2007.[2]", vision: "To be the unique worldwide icon of change towards a cancer‐ free childhood", founders: "Ola Ghabour, Sjerif Abouel Naga, Fakery Abdel Hamid, Somaya Abouelenein, Sohair Farghaly")
    // organization location
    var orgLocation: CLLocationCoordinate2D!
    
    // status bar background
    var statusBar: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.DN.DarkBlue.color()
        return vw
    }()
    
    // navigation bar contain dismiss button - and organization title
    var navBar: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.DN.DarkBlue.color()
        vw.alpha = 0.7
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
        lb.textColor = UIColor.DN.White.color()
        lb.font = UIFont.DN.Regular.font(size: 18)
        return lb
    }()
    
    // back button dismiss the view controller
    var dismissButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.tintColor = UIColor.DN.White.color()
        return btn
    }()
    
    var orgMapView : MKMapView!
    
    var location : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Location"
        return view
    }()
    
    
    var vision : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Our Vision"
        return view
    }()
    
    var address : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Address"
        return view
    }()
    var founder : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Founders"
        return view
    }()
    var mobile : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "Mobile"
        return view
    }()
    var about : DNDetailsView = {
        let view = DNDetailsView()
        view.title.text = "About"
        return view
    }()
    
    let scrollView : UIScrollView = {
        let scrollV = UIScrollView()
        //scrollV.alwaysBounceVertical = true
        //scrollV.hori
        //scrollV.bouncesZoom = false
        //scrollV.isDirectionalLockEnabled = true
        let screanSize = UIScreen.main.bounds
        scrollV.contentSize = CGSize(width: screanSize.width - 16 , height: 750)
        //scrollV.backgroundColor = .cyan
        return scrollV
    }()
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)//.white
        
        setupMapView()
        orgMapView.delegate = self
        setupLayout()
        
        
        // just for test
        orgTitle.text = org.title
        mobile.detailsView.text = org.concats
        address.detailsView.text = org.address
        about.detailsView.text = org.about
        vision.detailsView.text = org.vision
        founder.detailsView.text = org.founders
        
        dismissButton.addTarget(self, action: #selector(backBtnWasPressedb), for: .touchUpInside)
        
    }
    
    // convert the status bar color from black to white
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    //MARK:- setup subviews
    
    func setupMapView() {
        orgMapView = MKMapView()
        // specify organization's location
        orgLocation = CLLocationCoordinate2D(latitude: org.location.lat , longitude: org.location.log)
        let regoin = MKCoordinateRegion(center: orgLocation, latitudinalMeters: 10000, longitudinalMeters: 1000)
        orgMapView.setRegion(regoin, animated: true)
        
        // add Annotation
        orgMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let organizationAnnotation = DNAnnotation(coordinate: orgLocation, title: org.title, subtitle: org.about)
        orgMapView.addAnnotation(organizationAnnotation)
    }
    
    
    //MARK:- setup layout constraints
    func setupLayout() {
        view.addSubview(statusBar)
        view.addSubview(orgBackgroundImage)
        view.addSubview(navBar)
        navBar.addSubview(orgTitle)
        navBar.addSubview(dismissButton)
        // setup status bar constraint
        statusBar.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 20))
        // setup organization background image constraint
        orgBackgroundImage.DNLayoutConstraint(statusBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 200))
        // setup nav bar constraints
        navBar.DNLayoutConstraint(statusBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 50))
        orgTitle.DNLayoutConstraint(centerH: true, centerV: true)
        dismissButton.DNLayoutConstraint(left: navBar.leftAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        dismissButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor).isActive = true
        // setup details constraint
        let Vstack = UIStackView(arrangedSubviews: [location, address,vision, founder, mobile, about])
        Vstack.backgroundColor = .red
        Vstack.axis = .vertical
        Vstack.distribution = .fillProportionally
        Vstack.alignment = .fill
        Vstack.spacing = 8
        view.addSubview(scrollView)
        scrollView.addSubview(Vstack)
        location.detailsView.addSubview(orgMapView)
        orgMapView.DNLayoutConstraintFill()
        location.DNLayoutConstraint(size: CGSize(width: 0, height: 200))
        address.DNLayoutConstraint(size: CGSize(width: 0, height: 80))
        vision.DNLayoutConstraint(size: CGSize(width: 0, height: 80))
        founder.DNLayoutConstraint(size: CGSize(width: 0, height: 80))
        mobile.DNLayoutConstraint(size: CGSize(width: 0, height: 80))
        scrollView.DNLayoutConstraint(orgBackgroundImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 16, left: 16, bottom: 20, right: 16))
        Vstack.DNLayoutConstraint(size: CGSize(width: view.frame.width - 16, height: 750))
    }
    
    //MARK:- Button Action
    @objc func backBtnWasPressedb() {
           dismiss(animated: true, completion: nil)
       }

}

extension DonationDetailsVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let orgAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            orgAnnotation.animatesWhenAdded = true
            orgAnnotation.titleVisibility = .adaptive
            orgAnnotation.subtitleVisibility = .adaptive
            return orgAnnotation
        }
        return nil
    }
}
