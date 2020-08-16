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
    var firstTime: Bool = true
    var inProcess: Bool = false
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
        //NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
        updateBalance()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateBalance() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
                print("Timer ask for Balance?")
                if !self.inProcess {
                    self.loadUserBalances()
                    print("YES.")
                } else {
                    print("NO.")
                }
            }
        }
    }
    
    func configure() {
        collectionView.alpha = 0
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
        if firstTime { showLoadingView() }
        self.inProcess = true
        TransferManager.shared.getUserBalace { [weak self] (result) in
            guard let self = self else {return}
            if self.firstTime { self.dismissLoadingView() }
            switch result {
                case .success(let data):
                    //self.handleGetUserBalanceSuccessCase(withData: data)
                    self.handleSucessCase(withData: data)
                case .failure(let err):
                    self.handleGetUserBalanceFailureCase(withError: err.localizedDescription)
            }
        }
    }
    //TEST TEST
    private func handleSucessCase(withData data: [Balance]) {
        if firstTime {
            firstTime = false
            self.balance = data
            prepareDataForPay(balance: data)
            DispatchQueue.main.async {
                self.collectionView.alpha = 1.0
                self.collectionView.reloadData()
            }
        } else {
            guard let oldBalance = loadOldBalance() else { return }
            if showReloadCollection(new: data, old: oldBalance) {
                prepareDataForPay(balance: data)
                self.balance = data
                DispatchQueue.main.async { self.showLoadingView(withLabel: "Updating...") }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    self.dismissLoadingView()
                    self.collectionView.alpha = 1.0
                    self.collectionView.reloadData()
                })
            }
        }
        inProcess = false
    }
    
    
    private func handleGetUserBalanceSuccessCase(withData data: [Balance]) {
        self.balance = data
        prepareDataForPay(balance: data)
        DispatchQueue.main.async {
            self.collectionView.alpha = 1.0
            self.collectionView.reloadData()
        }
    }
    
    private func handleGetUserBalanceFailureCase(withError error: String) {
        print("Failure Get Balance: \(error)")
        inProcess = false
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
    
    //TEST TEST
    private func showReloadCollection(new: [Balance], old: [Balance])-> Bool {
        guard new[0].amount == old[0].amount else { return true }
        guard new[1].amount == old[1].amount else { return true }
        guard new[2].amount == old[2].amount else { return true }
        guard new[3].amount == old[3].amount else { return true }
        return false
    }
    
    private func loadOldBalance() -> [Balance]? {
            do {
                let decoder = PropertyListDecoder()
                let data = try Data(contentsOf: documentFilePath!)
                let balance = try decoder.decode([Balance].self, from: data)
                return balance
            } catch { return nil }
    }
}
