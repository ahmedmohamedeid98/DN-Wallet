//
//  UserHistoryVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit


class UserHistoryVC: UIViewController {
    
    var consumData = [HistoryCategory]()
    var reciveData = [HistoryCategory]()
    var donationData = [HistoryCategory]()
    var data: History?
    lazy var meManager: MeManagerProtocol = MeManager()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    private var currentIndex: Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNextButton()
        configureCollectionView()
        setupNavigationBar()
        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func configureNextButton() {
        nextButton.layer.cornerRadius = nextButton.frame.size.height / 2
        nextButton.layer.shadowColor = UIColor.label.cgColor
        nextButton.layer.shadowOffset = CGSize(width: 0.26, height: 0.26)
        nextButton.layer.shadowOpacity = 0.26
        nextButton.layer.shadowRadius = 8
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
        if let _data = data {
            if indexPath.row == 0 {         cell.transactionAmount = _data.consumption }
            else if indexPath.row == 1 {    cell.transactionAmount = _data.recevie }
            else {                          cell.transactionAmount = _data.donate }
        } else {
            cell.transactionAmount = 0
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
//MARK:- Networking
extension UserHistoryVC {
    
    func loadData() {
        meManager.getMyHisory { result in
            switch result {
                case .success(let data):
                    self.historySuccess(data: data)
                case .failure(let err):
                    self.historyFailure(err: err.localizedDescription)
            }
        }
    }
    
    private func historySuccess(data: History) {
        self.data = data
        DispatchQueue.main.async { self.collectionView.reloadData() }
        
        for item in data.result {
            if item.category == "1" {
                consumData.append(item)
            } else if item.category == "2" {
                reciveData.append(item)
            } else {
                donationData.append(item)
            }
        }
    }
    
    private func historyFailure(err: String) {
        print("filuew: \(err)")
    }
}
