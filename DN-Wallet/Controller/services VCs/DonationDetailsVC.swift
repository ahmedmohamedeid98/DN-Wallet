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

    
    private var data : CharityDetailsResponse?
    private var charityTable: UITableView!
    private var mapView: MKMapView!
    var charityID: String?
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupNavBar()
        setupTableView()
        setupLayout()
        mapView = MKMapView()
        mapView.delegate = self
        loadData()
    }
    
    func loadData() {
        if let id = charityID {
            DNData.getCharityOrganizationDetails(withID: id, onView: view) { (details, error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                if let safeDetails = details {
                    self.data = safeDetails
                    DispatchQueue.main.async {
                        let initialLocation = CLLocation(latitude: safeDetails.location.lat, longitude: safeDetails.location.lan)
                        self.mapView.centerToLocation(initialLocation, regionReduis: 10000)
                        self.mapView.setMapZoomAndBoundryRange(center: initialLocation, distance: 60000)
                        self.addMapViewAnnotaton(at: initialLocation, title: safeDetails.name, subtitle: safeDetails.phone)
                        self.charityTable.alpha = 1.0
                        self.charityTable.reloadData()
                    }
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    //MARK:- setup subviews
    func setupNavBar() {
        navigationItem.title = data?.name
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        let donateBarButton = UIBarButtonItem(title: K.vc.donateDetailtsTitle , style: .plain, target: self, action: #selector(donateButtonPressed))
        navigationItem.rightBarButtonItem = donateBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    @objc func donateButtonPressed() {
        let st = UIStoryboard(name: "Services", bundle: .main)
        guard let vc = st.instantiateViewController(identifier: "sendAndRequestVC") as? SendAndRequestMoney else { return }
        vc.presentFromDonationVC = true
        vc.presentedEmail = data?.email ?? "Not valid email, Try Again"
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTableView() {
        charityTable = UITableView(frame: .zero, style: .grouped)
        charityTable.delegate = self
        charityTable.dataSource = self
        charityTable.register(UINib(nibName: "DonationDetailsCell", bundle: nil), forCellReuseIdentifier: DonationDetailsCell.reuseIdentifier)
        charityTable.estimatedRowHeight = UITableView.automaticDimension
        charityTable.backgroundColor = .clear
        charityTable.allowsSelection = false
        charityTable.separatorStyle = .none
        charityTable.showsVerticalScrollIndicator = false
        charityTable.alpha = 0.0
    }
    
    
    //MARK:- setup layout constraints
    func setupLayout() {
        view.addSubview(charityTable)
        charityTable.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}

extension DonationDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DonationDetailsSectoin.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = charityTable.dequeueReusableCell(withIdentifier: DonationDetailsCell.reuseIdentifier, for: indexPath) as? DonationDetailsCell else {return UITableViewCell()}
        guard let section = DonationDetailsSectoin(rawValue: indexPath.row) else { return UITableViewCell() }
        guard let detail = data else { return UITableViewCell() }
        cell.title.text = section.description
        switch section {
            case .Vision:   cell.content.text = detail.vision
            case .Address:  cell.content.text = detail.address
            case .Founders: cell.content.text = detail.founders
            case .Concat:   cell.content.text = detail.phone
            case .About:    cell.content.text = detail.about
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "Location"
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = #colorLiteral(red: 0.167981714, green: 0.6728672981, blue: 0.9886779189, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        header.addSubview(titleLabel)
        header.addSubview(mapView)
        titleLabel.DNLayoutConstraint(header.topAnchor, left: header.leftAnchor, right: header.rightAnchor, size: CGSize(width: 0, height: 35))
        mapView.DNLayoutConstraint(titleLabel.bottomAnchor, left: header.leftAnchor, right: header.rightAnchor, bottom: header.bottomAnchor, margins: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }

}

extension DonationDetailsVC: MKMapViewDelegate {
    
    private func addMapViewAnnotaton(at location: CLLocation , title: String, subtitle: String) {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let organizationAnnotation = DNAnnotation(coordinate: location.coordinate, title: title, subtitle: subtitle)
        mapView.addAnnotation(organizationAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let orgAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            orgAnnotation.animatesWhenAdded = true
            orgAnnotation.titleVisibility = .adaptive
            orgAnnotation.subtitleVisibility = .adaptive
            return orgAnnotation
        }
        print("nil annotation")
        return nil
    }
}
extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionReduis: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionReduis,
                                                  longitudinalMeters: regionReduis)
        setRegion(coordinateRegion, animated: true)
    }
    func setMapZoomAndBoundryRange(center: CLLocation, distance: CLLocationDistance) {
        let region = MKCoordinateRegion(center: center.coordinate,
                                        latitudinalMeters: distance,
                                        longitudinalMeters: distance)
        let boundaryRange = MKMapView.CameraBoundary(coordinateRegion: region)
        setCameraBoundary(boundaryRange, animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        setCameraZoomRange(zoomRange, animated: true)
    }
}
