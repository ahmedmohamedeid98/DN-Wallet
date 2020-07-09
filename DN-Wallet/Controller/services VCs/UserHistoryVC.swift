//
//  UserHistoryVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit


class UserHistoryVC: UIViewController {
    
    //TEST TEST TEST
    var hh: [HistoryCategory] =
    [
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 0, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 0, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 1, innerCategory: 1),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "XCN", date: "25-7-23 8:06", category: 0, innerCategory: 1),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "USD", date: "25-7-23 8:06", category: 1, innerCategory: 1),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 2, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 2, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 2, innerCategory: 0)
    ]
    var consumData = [HistoryCategory]()
    var reciveData = [HistoryCategory]()
    var donationData = [HistoryCategory]()
    
    // ============== TEST TEST ===========

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    private var currentIndex: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 2
        configureCollectionView()
        setupNavigationBar()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupNavigationBar() {
        self.configureNavigationBar(title: K.vc.historyTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(backBtnWasPressed))
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc private func backBtnWasPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        let row = currentIndex >= UserHistorySections.allCases.count ? 0 : currentIndex
        let indexpath = IndexPath(row: row, section: 0)
        
        if row == 0 {
            scrollTo(indexpath, position: .top)
            currentIndex = 0
        } else {
            scrollTo(indexpath, position: .bottom)
        }
        
        currentIndex += 1
    }
    
    private func scrollTo(_ indexPath: IndexPath, position: UICollectionView.ScrollPosition) {
        collectionView.scrollToItem(at: indexPath, at: position, animated: true)
    }

}

extension UserHistoryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserHistorySections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserHistoryCell.identifier, for: indexPath) as? UserHistoryCell else { return UICollectionViewCell() }
        let section = UserHistorySections(rawValue: indexPath.row)
        cell.data = section
        cell.transactionAmount = 2500.451
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("cell take size")
        return CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.height - 20)
    }
    
}

extension UserHistoryVC: UserHistoryCellProtocol {
    
    
    func detailsAction(action: UserHistoryCellDetailsAction) {
        switch action {
            case .consumptionAction:
                pushHistoryDetails(.consumptions, data: consumData)
            case .recievedAction:
                pushHistoryDetails(.received, data: reciveData)
            case .dontationAction:
                pushHistoryDetails(.donation, data: donationData)
        }
    }
    
    
    
    private func pushHistoryDetails(_ category: UserHistorySections, data: [HistoryCategory]) {
        let vc = HistoryDetailsVC()
        vc.modalPresentationStyle = .fullScreen
        vc.configureController(withData: data, forCategory: category)
        navigationController?.pushViewController(vc, animated: true)
    }
}
    
