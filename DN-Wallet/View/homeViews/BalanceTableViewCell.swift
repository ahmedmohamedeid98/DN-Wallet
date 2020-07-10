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
    @IBOutlet weak var collectionView: UICollectionView!
    static let identifier = "BalanceTableViewCell"
    var balances: [Balance] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    //MARK:- Init
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BalanceCollectionCell.nib(), forCellWithReuseIdentifier: BalanceCollectionCell.identifier)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "BalanceTableViewCell", bundle: nil)
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
