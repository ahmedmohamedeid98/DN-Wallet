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
    var balances: [Balance] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configure()
        addCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(BalanceCollectionCell.nib(), forCellWithReuseIdentifier: BalanceCollectionCell.identifier)
    }
    
    func addCollectionView() {
        addSubview(collectionView)
        collectionView.DNLayoutConstraintFill()
    }
}
extension BalanceTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return balances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BalanceCollectionCell.identifier, for: indexPath) as! BalanceCollectionCell
        cell.data = balances[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.size.width / 2 - 5, height: 50)
    }
}
