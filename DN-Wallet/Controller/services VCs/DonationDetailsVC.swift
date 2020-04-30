//
//  DonationDetailsVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/18/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
import MapKit

enum DonationDetailsSectoin: Int, CaseIterable, CustomStringConvertible {
    case Location
    case Vision
    case Address
    case Founders
    case Concat
    case About
    
    var description: String {
        switch self {
        case .Location: return "Location"
        case .Vision: return "Vision"
        case .Address: return "Address"
        case .Founders: return "Founders"
        case .Concat: return "Concats"
        case .About: return "About"
        }
    }
    
}
struct charityLocation {
    let location: Location
    let title: String
    let subtitle: String
}

class DonationDetailsVC: UIViewController {

    
    var data : CharityOrg?
    var charityTable: UITableView!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnBackgroundColor
        setupNavBar()
        setupTableView()
        setupLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    //MARK:- setup subviews
    func setupNavBar() {
        navigationItem.title = data?.title
        navigationController?.navigationBar.barTintColor = .DnDarkBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        let donateBarButton = UIBarButtonItem(title: "Donate", style: .plain, target: self, action: #selector(donateButtonPressed))
        navigationItem.rightBarButtonItem = donateBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func donateButtonPressed() {
        let vc = SendAndRequestMoney()
        vc.presentFromDonationVC = true
        vc.presentedEmail = data?.email ?? "Not valid email, Try Again"
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTableView() {
        charityTable = UITableView()
        charityTable.delegate = self
        charityTable.dataSource = self
        charityTable.register(DonationDetailsCell.self, forCellReuseIdentifier: DonationDetailsCell.reuseIdentifier)
        charityTable.backgroundColor = .DnBackgroundColor
        charityTable.allowsSelection = false
        charityTable.indicatorStyle = .white
    }
    
    
    //MARK:- setup layout constraints
    func setupLayout() {
        view.addSubview(charityTable)
        charityTable.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
    }
}

extension DonationDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DonationDetailsSectoin.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = charityTable.dequeueReusableCell(withIdentifier: DonationDetailsCell.reuseIdentifier, for: indexPath) as? DonationDetailsCell else {return UITableViewCell()}
        guard let section = DonationDetailsSectoin(rawValue: indexPath.section) else { return UITableViewCell() }
        guard let detail = data else { return UITableViewCell() }
        switch section {
        case .Location: cell.locationAndDetails = charityLocation(location:detail.location, title: detail.title, subtitle: detail.about)
        case .Vision:   cell.caseDescription = detail.vision
        case .Address:  cell.caseDescription = detail.address
        case .Founders: cell.caseDescription = detail.founders
        case .Concat:   cell.caseDescription = detail.concats
        case .About:    cell.caseDescription = detail.about
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let label = UILabel()
        label.basicConfigure(fontSize: 18)
        label.textAlignment = .center
        let section = DonationDetailsSectoin(rawValue: section)
        label.text = section?.description
        vw.addSubview(label)
        label.DNLayoutConstraint(vw.topAnchor, left: vw.leftAnchor, right: vw.rightAnchor, bottom: vw.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        return vw
    }
    
    func getCellHeight(text: String?) -> CGFloat {
        if let txt = text {
            let height = txt.heightWithConstrainedWidth(width: self.charityTable.frame.size.width - 40, font: UIFont.DN.Regular.font(size: 18))
            return height + 40
        }else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 170
        guard let section = DonationDetailsSectoin(rawValue: indexPath.section) else { return height }
        switch section {
        case .Location: return height
        case .Vision:   return getCellHeight(text: data?.vision)
        case .Address:  return getCellHeight(text: data?.address)
        case .Founders: return getCellHeight(text: data?.founders)
        case .Concat:   return getCellHeight(text: data?.concats)
        case .About:    return getCellHeight(text: data?.about)
        }
    }
}
