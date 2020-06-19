//
//  PartenerTableViewCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 6/16/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

struct Partener {
    let imageName: String
    let title: String
}

class PartenerTableViewCell: UITableViewCell {

    //MARK:- Properities
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollRightBtnOutlet: UIButton!
    @IBOutlet weak var scrollLeftBtnOutlet: UIButton!
    static let identifier = "PartenerTableViewCell"
    var parteners: [Partener] = [] {
        didSet {
            itemCount = parteners.count
            collectionView.reloadData()
            print("image comes: \(itemCount)")
        }
    }
    fileprivate var counter: Int = 0
    fileprivate var itemCount: Int = 0
    fileprivate var timer: Timer!
    
    
    //MARK:- Init
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PartenerCollectionCell.nib(), forCellWithReuseIdentifier: PartenerCollectionCell.identifier)
        let rightPath = UIBezierPath(roundedRect: scrollRightBtnOutlet.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 30, height: 30))
        let rMaskLayer = CAShapeLayer()
        rMaskLayer.path = rightPath.cgPath
        scrollRightBtnOutlet.layer.mask = rMaskLayer
        
        let leftPath = UIBezierPath(roundedRect: scrollLeftBtnOutlet.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        let lMaskLayer = CAShapeLayer()
        lMaskLayer.path = leftPath.cgPath
        scrollLeftBtnOutlet.layer.mask = lMaskLayer
    }
    
    
    //MARK:- Methods
    static func nib() -> UINib {
        return UINib(nibName: "PartenerTableViewCell", bundle: nil)
    }
    
    // setup Timer
    func startTimer() {
        if itemCount > 0 {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.slideShow), userInfo: nil, repeats: true)
            }
        }
        
    }
    // stop timer
    func stopTimer() {
        if let _ = timer {
            timer.invalidate()
        }
        
    }
    // timer's action
    @objc func slideShow() {
           if counter < itemCount {
               slideToItemAt(counter)
               counter += 1
           }else {
               counter = 0
               slideToItemAt(counter, animate: false)
               counter = 1
           }
       }
    
    @IBAction fileprivate func scrollToRightButton(_ sender: UIButton) {
        if counter < itemCount {
            slideToItemAt(counter, animate: true)
            counter += 1
        }else {
            counter = 0
            slideToItemAt(counter, animate: false)
            counter = 1
        }
    }
    
    @IBAction fileprivate func scrollToLeftButton(_ sender: UIButton) {
        if counter > 0 {
            slideToItemAt(counter, animate: true)
            counter -= 1
        }else {
            counter = itemCount - 1
            slideToItemAt(counter, animate: true)
            counter = itemCount
        }
    }
    
    fileprivate func slideToItemAt(_ counter: Int, animate: Bool = true) {
        let index = IndexPath(item: counter, section: 0)
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animate)
        pageControl.currentPage = counter
    }
    
    
}
//MARK:- Collection view
extension PartenerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("partenersCount: \(parteners.count)")
        return parteners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartenerCollectionCell.identifier, for: indexPath) as! PartenerCollectionCell
        print("partenerImage: \(parteners[indexPath.row].imageName)")
        cell.data = parteners[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.size.width, height: 400)
    }
    
    
}
