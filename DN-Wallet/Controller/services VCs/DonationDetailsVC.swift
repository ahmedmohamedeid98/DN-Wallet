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
    var charityName: String?
    private lazy var charityManager: CharityManagerProtocol = CharityManager()
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupNavBar()
        if let title = charityName { self.navigationItem.title = title }
        setupTableView()
        setupLayout()
        mapView = MKMapView()
        mapView.delegate = self
        loadData()
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
        vc.charityId = charityID
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
        let header                  = UIView()
        let titleLabel              = DNTitleLabel(textAlignment: .center, fontSize: 17)
        titleLabel.textColor        = .white
        titleLabel.text             = "Location"
        titleLabel.backgroundColor  = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1)
        header.addSubview(titleLabel)
        header.addSubview(mapView)
        titleLabel.DNLayoutConstraint(header.topAnchor, left: header.leftAnchor, right: header.rightAnchor, size: CGSize(width: 0, height: 35))
        mapView.DNLayoutConstraint(titleLabel.bottomAnchor, left: header.leftAnchor, right: header.rightAnchor, bottom: header.bottomAnchor, margins: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
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

//MARK:- Networking
extension DonationDetailsVC {
    func loadData() {
        if let id = charityID {
            Hud.showLoadingHud(onView: view, withLabel: "Get Details...")
            charityManager.getCharityDetails(withId: id) { [weak self] (result) in
                guard let self = self else { return }
                Hud.hide(after: 0.0)
                switch result {
                    case .success(let data):
                        self.configureNetworkingSuccessCase(withData: data)
                    case .failure(let error):
                        self.configureNetworkingFailureCase(withError: error.localizedDescription)
                }
            }
        }
    }
    private func configureNetworkingSuccessCase(withData data: CharityDetailsResponse) {
        self.data = data
        DispatchQueue.main.async {
            let initialLocation = CLLocation(latitude: data.location.lat, longitude: data.location.lan)
            self.mapView.setMapZoomAndBoundryRange(center: initialLocation, distance: 60000)
            self.mapView.centerToLocation(initialLocation, regionReduis: 1000)
            self.addMapViewAnnotaton(at: initialLocation, title: data.name, subtitle: data.phone)
            self.charityTable.alpha = 1.0
            self.charityTable.reloadData()
        }
    }
    
    private func configureNetworkingFailureCase(withError error: String) {
        self.presentDNAlertOnTheMainThread(title: "Failure", Message: error)
    }
}
