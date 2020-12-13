//
//  HistoryDetailsVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HistoryDetailsVC: UIViewController {
    
    
    
    func configureController(withData data: [HistoryCategory], forCategory category: UserHistorySections) {
        navBarTitle = category.title
        segmentItems = category.segmentItems
        tableViewData = data
        infoLabel.text = category.infoLabel
        withSegmentController = category.withSegment
    }
    
    func seperateData(_ data: [HistoryCategory]) {
        for item in data {
            if item.inner_category == "1" {
                firstSemgentData.append(item)
            }else{
                secondSegmentData.append(item)
            }
        }
    }
    
    // customization properities
    var navBarTitle: String!
    var segmentItems: [String]!
    var infoLabel : UILabel = {
        let info = UILabel()
        info.textAlignment = .center
        info.textColor = .DnColor
        info.font = UIFont.DN.Regular.font(size: 16)
        return info
    }()
    var withSegmentController: Bool = true
    
    
    //MARK:- Properities
    // create a instance from custom navigation controller
    //var navBar:DNNavBar!
    var segmentController:DNSegmentControl!
    var tableView:UITableView!
    
    // data section, HCard: history card contains 'Email', 'Amount', 'Date' and 'Currancy' for any transaction
    var firstSemgentData = [HistoryCategory]()
    var secondSegmentData = [HistoryCategory]()
    var tableViewData = [HistoryCategory]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupNavigationBar() 
        if withSegmentController {
            setupSegmentController()
            seperateData(tableViewData)
        }
        setupTableView()
        setupLayout()
        if !(navBarTitle == "DONATIONS") {
            tableViewData = firstSemgentData
        }
        
    }
    
    deinit {
        print("HistoryDetails deallocated")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    /// selector action: left nav bar item dismiss view controller when it pressed
    @objc func leftBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    /// initialized segment controller
    func setupSegmentController() {
        segmentController = DNSegmentControl(frame: .zero)
        segmentController.firstSegmentTitle = segmentItems[0]
        segmentController.secondSegmentTitle = segmentItems[1]
        segmentController.delegate = self
    }
    
    func setupNavigationBar() {
        navigationItem.title = navBarTitle
        navigationController?.navigationBar.barTintColor = .DnColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    /// initialize table view
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "HistoryDetailsCell", bundle: nil), forCellReuseIdentifier: HistoryDetailsCell.reuseIdentifier)
    }
    
    
    /// add views and constraints to the controller's view
    func setupLayout() {
        view.addSubview(infoLabel)
        
        infoLabel.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), centerH: true)
        
        var tableTopAnchor: NSLayoutYAxisAnchor = infoLabel.bottomAnchor
        
        if withSegmentController {
            view.addSubview(segmentController)
            segmentController.DNLayoutConstraint(infoLabel.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 300, height: 40), centerH: true)
            tableTopAnchor = segmentController.bottomAnchor
        }
        
        view.addSubview(tableView)
        tableView.DNLayoutConstraint(tableTopAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }


}

// configure table view

extension HistoryDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryDetailsCell.reuseIdentifier, for: indexPath) as? HistoryDetailsCell else { return UITableViewCell() }
        let currentData = tableViewData[indexPath.row]
        cell.configureCell(email: currentData.email , amount: "\(currentData.amount) \(currentData.currencuy_code)" , date: "\(currentData.date)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

extension HistoryDetailsVC: DNSegmentControlDelegate {
    func segmentValueChanged(to index: Int) {
        if index == 0 {
            tableViewData = firstSemgentData
            tableView.reloadData()
        } else {
            tableViewData = secondSegmentData
            tableView.reloadData()
        }
    }
}
