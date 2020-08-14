//
//  BalanceTableViewCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {

    //MARK:- Properities
    var collectionView: UICollectionView!
    static let identifier = "BalanceTableViewCell"
    let documentFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Balance.plist")
    var balance: [Balance] = []
//    {
//        didSet {
//            DispatchQueue.main.async { self.collectionView.reloadData() }
//        }
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addCollectionView()
        configure()
        loadUserBalances()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateBalance() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { _ in
                self.loadUserBalances()
                print("::::::Balance was updated.")
            }
        }
    }
    
    func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(BalanceCollectionCell.nib(), forCellWithReuseIdentifier: BalanceCollectionCell.identifier)
    }
    
    func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.DNLayoutConstraintFill()
    }
}
extension BalanceTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return balance.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCollectionCell.identifier, for: indexPath) as! BalanceCollectionCell
        cell.data = balance[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.size.width / 2 - 5, height: 50)
    }
}

//MARK:- Networking
extension BalanceTableViewCell {
    
    func loadUserBalances() {
        print("load balance...")
        TransferManager.shared.getUserBalace { (result) in
            switch result {
                case .success(let data):
                    self.handleGetUserBalanceSuccessCase(withData: data)
                case .failure(let err):
                    self.handleGetUserBalanceFailureCase(withError: err.localizedDescription)
            }
        }
    }
    
    private func handleGetUserBalanceSuccessCase(withData data: [Balance]) {
        self.balance = data
        prepareDataForPay(balance: data)
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    private func handleGetUserBalanceFailureCase(withError error: String) {
        print("Failure Get Balance: \(error)")
    }
    
    private func prepareDataForPay(balance: [Balance]) {
        let coder = PropertyListEncoder()
        do {
            let data = try coder.encode(balance)
            try data.write(to: documentFilePath!)
        } catch {
            print("Error to write balabce")
        }
    }
}
