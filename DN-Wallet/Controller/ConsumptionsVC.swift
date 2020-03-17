//
//  ConsumptionsVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 3/13/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class historyDetailsVC: UIViewController {
 
    
    /// Customize Controller View titles and data and determine the segment controller existance
    /// - Parameters:
    ///   - title: navigation bar title
    ///   - segItems: segmentation controller items
    ///   - seg: determine if the view controller should contain segment controller or not like donation vc
    func configureController(title: String, segItems: [String] = [], firstData fst: [HCard] = [], secondData sec: [HCard] = [], withSeg seg:Bool = true) {
        navBarTitle = title
        segmentItems = segItems
        withSegmentController = seg
        firstSegment = fst
        secondSegment = sec
    }
    
    // customization variables
    var withSegmentController: Bool!
    var navBarTitle: String!
    var segmentItems : [String]!
    
    //MARK:- Properities
    var navBar: DNNavBar!
    var tableView: UITableView!
    var segmentController: UISegmentedControl!
    var infoLabel : UILabel = {
        let info = UILabel()
        info.text = "Your Send history to"
        info.textColor = UIColor.DN.DarkBlue.color()
        info.font = UIFont.DN.Regular.font(size: 16)
        info.textAlignment = .center
        return info
    }()
    
    var firstSegment = [HCard]()
    var secondSegment = [HCard]()
    
    
    var tableData : [HCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        if withSegmentController {
            setupSegmentController()
        }
        setupTableView()
        setupLayout()
        tableData = firstSegment
        
    }
    
    /// setup the custom navigation view 'DNNavBar'
    func setupNavBar() {
        navBar = DNNavBar()
        navBar.title.text = navBarTitle
        navBar.addLeftItem(imageName: "arrow.left")
        navBar.leftBtn.addTarget(self, action: #selector(backBtnWasPressed), for: .touchUpInside)
    }
    
    /// Selector Action: this method called when left button pressed which dismiss the view controller
    @objc func backBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Initialize the table view
    func setupTableView() {
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(consumptionCell.self, forCellReuseIdentifier: "CONSUMIDENTIFIER")
    }
    
    /// initialize the segment controller
    func setupSegmentController() {
        segmentController = UISegmentedControl(items: segmentItems )
        segmentController.selectedSegmentTintColor = UIColor.DN.DarkBlue.color()
        segmentController.selectedSegmentIndex = 0
        segmentController.tintColor = .white
        segmentController.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    /// Selector Action: this method called when the selected segment changed which change the table view data
    @objc func valueChanged() {
        switch segmentController.selectedSegmentIndex {
        case 0:
            tableData = firstSegment
            tableView.reloadData()
        case 1:
            tableData = secondSegment
            tableView.reloadData()
        default:
            break
        }
    }
    
    /// method called to setup the layout constraints
    func setupLayout() {
    
        view.addSubview(navBar)
        view.addSubview(infoLabel)
        view.addSubview(tableView)
        
        navBar.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, size: CGSize(width: 0, height: 100))
        infoLabel.DNLayoutConstraint(navBar.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), centerH: true)
        var tableTopAnchor: NSLayoutYAxisAnchor = infoLabel.bottomAnchor
        
        if withSegmentController {
            view.addSubview(segmentController)
            segmentController.DNLayoutConstraint(infoLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, margins: UIEdgeInsets(top: 20, left: 40, bottom: 0, right: 40))
            tableTopAnchor = segmentController.bottomAnchor
        }
        tableView.DNLayoutConstraint(tableTopAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))
    }
    

}

// configure table view
extension historyDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CONSUMIDENTIFIER", for: indexPath) as? consumptionCell else {return UITableViewCell() }
        let currentHCard = tableData[indexPath.row]
        
        cell.configureCell(email: currentHCard.email, amount: currentHCard.amount, date: "\(currentHCard.date)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
}
