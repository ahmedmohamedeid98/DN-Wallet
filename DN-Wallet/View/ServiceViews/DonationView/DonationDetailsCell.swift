//
//  DonationDetailsCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/28/20.
//  Copyright © 2020 DN. All rights reserved.
//

import MapKit

class DonationDetailsCell: UITableViewCell {
    
    static let reuseIdentifier = "donatio-details-cell-identifier"
    
    var locationAndDetails: charityLocation? {
        didSet {
            setupMapView()
            guard let loc = locationAndDetails else {return}
            addMapView(location: loc.location , title: loc.title, subtitle: loc.subtitle)
        }
    }
    
    var caseDescription: String? {
        didSet {
            addTextView()
            guard let txt = caseDescription else { return }
            txtView.text = txt
        }
    }
    let txtView: UITextView = {
        let txt = UITextView()
        txt.font = UIFont.DN.Regular.font(size: 16)
        txt.textColor = .black
        txt.isEditable = false
        return txt
    }()
    var orgMapView: MKMapView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTextView() {
        addSubview(txtView)
        txtView.DNLayoutConstraint(topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor,  margins: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    func setupMapView() {
        orgMapView = MKMapView()
        orgMapView.delegate = self
        addSubview(orgMapView)
            orgMapView.DNLayoutConstraint(topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, margins: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    private func addMapView(location: Location, title: String, subtitle: String) {
        // specify organization's location
        let orgLocation = CLLocationCoordinate2D(latitude: location.lat , longitude: location.log)
        let regoin = MKCoordinateRegion(center: orgLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        orgMapView.setRegion(regoin, animated: true)
        
        // add Annotation
        orgMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let organizationAnnotation = DNAnnotation(coordinate: orgLocation, title: title, subtitle: subtitle)
        orgMapView.addAnnotation(organizationAnnotation)
    }
}

extension DonationDetailsCell: MKMapViewDelegate {
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
