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
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    static let identifier = "PartenerTableViewCell"
    private var counter: Int = 0
    private var itemCount: Int = 0
    private var timer: Timer!
    
    var parteners: [Partener] = [] {
        didSet {
            itemCount = parteners.count
            print("image comes, itemCount: \(itemCount)")
            collectionView.reloadData()
        }
    }
    
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configureCollectionView()
        configurePageControl()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Configures
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(PartenerCollectionCell.self, forCellWithReuseIdentifier: PartenerCollectionCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configurePageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = parteners.count
        pageControl.backgroundColor = .red
        pageControl.currentPageIndicatorTintColor = .DnColor
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.hidesForSinglePage = true
    }
    
    func configureLayout() {
        
        addSubview(collectionView)
        collectionView.DNLayoutConstraintFill()
        
        addSubview(pageControl)
        pageControl.DNLayoutConstraint(bottom: bottomAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0),size: CGSize(width: 80, height: 40), centerH: true)
        
        
    }
    
    //MARK:- Timer
   
    func startTimer() {
        if itemCount > 0 {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 9, target: self, selector: #selector(self.slideShow), userInfo: nil, repeats: true)
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
            DispatchQueue.main.async { self.slideToItemAt(self.counter) }
               counter += 1
           }else {
               counter = 0
            DispatchQueue.main.async { self.slideToItemAt(self.counter, animate: false) }
               counter = 1
           }
       }
    
    private func slideToItemAt(_ counter: Int, animate: Bool = true) {
        let index = IndexPath(item: counter, section: 0)
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animate)
        pageControl.currentPage = counter
    }
    
    
}
//MARK:- Collection view
extension PartenerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parteners.count
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartenerCollectionCell.identifier, for: indexPath) as! PartenerCollectionCell
        cell.data = parteners[indexPath.row]
        return cell
    }
    /*
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionview.contentOffset, size: self.collectionview.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionview.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 10)
    }
}
