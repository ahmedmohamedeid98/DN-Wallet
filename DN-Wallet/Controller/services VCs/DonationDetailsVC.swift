//
//  DonationDetailsVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
import MapKit

class DonationDetailsVC: UIViewController {

    
    var org : CharityOrg!
    // organization location
    var orgLocation: CLLocationCoordinate2D!
    
    // organization image
    var orgBackgroundImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "test1")
        return img
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
        let screanSize = UIScreen.main.bounds
        scrollV.contentSize = CGSize(width: screanSize.width - 16 , height: 750)
        //scrollV.backgroundColor = .cyan
        return scrollV
    }()
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        setupMapView()
        orgMapView.delegate = self
        setupLayout()
        // just for test
        navigationItem.title = org.title
        mobile.detailsView.text = org.concats
        address.detailsView.text = org.address
        about.detailsView.text = org.about
        vision.detailsView.text = org.vision
        founder.detailsView.text = org.founders
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    //MARK:- setup subviews
    
    func setupNavBar() {
        //navigationController?.navigationBar.barTintColor = UIColor.lightGray
        navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 154/255, green: 124/255, blue: 124/255, alpha: 0.4)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
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
        view.addSubview(orgBackgroundImage)
        // setup organization background image constraint
        orgBackgroundImage.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 200))
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
