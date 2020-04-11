//
//  HistoryDetailsVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HistoryDetailsVC: UIViewController {
    
    
    
    func configureController(title: String, segItems: [String] = [], data:[HistoryCategory], infoLabel info: String, withSeg: Bool = true) {
        navBarTitle = title
        segmentItems = segItems
        tableViewData = data
        infoLabel.text = info
        withSegmentController = withSeg
    }
    
    func seperateData(_ data: [HistoryCategory]) {
        for item in data {
            if item.innerCategory == 0 {
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
        info.text = "TEST TEST TEST"
        info.textAlignment = .center
        info.textColor = UIColor.DN.DarkBlue.color()
        info.font = UIFont.DN.Regular.font(size: 16)
        return info
    }()
    var withSegmentController: Bool = true
    
    
    //MARK:- Properities
    // create a instance from custom navigation controller
    //var navBar:DNNavBar!
    var segmentController:UISegmentedControl!
    var tableView:UITableView!
    
    // data section, HCard: history card contains 'Email', 'Amount', 'Date' and 'Currancy' for any transaction
    var firstSemgentData = [HistoryCategory]()
    var secondSegmentData = [HistoryCategory]()
    var tableViewData = [HistoryCategory]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar() 
        if withSegmentController {
            setupSegmentController()
            seperateData(tableViewData)
        }
        setupTableView()
        setupLayout()
        tableViewData = firstSemgentData
        
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
        segmentController = UISegmentedControl(items: segmentItems)
        segmentController.selectedSegmentIndex = 0
        segmentController.tintColor = .white
        segmentController.selectedSegmentTintColor = UIColor.DN.DarkBlue.color()
        segmentController.addTarget(self, action: #selector(valueWasChanged), for: .valueChanged)
    }
    
    /// selector action: this method called when selected segment being changed
    @objc func valueWasChanged() {
        switch segmentController.selectedSegmentIndex {
        case 0:
            tableViewData = firstSemgentData
            tableView.reloadData()
        case 1:
            tableViewData = secondSegmentData
            tableView.reloadData()
        default:
            print("unknow")
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = navBarTitle
        navigationController?.navigationBar.barTintColor = UIColor.DN.DarkBlue.color()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    /// initialize table view
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(HistoryDetailsCell.self, forCellReuseIdentifier: "historydetailscellidentifier")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historydetailscellidentifier", for: indexPath) as? HistoryDetailsCell else { return UITableViewCell() }
        let currentData = tableViewData[indexPath.row]
        cell.configureCell(email: currentData.email , amount: "\(currentData.amount) \(currentData.currency)" , date: "\(currentData.date)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
