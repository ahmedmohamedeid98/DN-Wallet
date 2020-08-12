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

protocol PartenerCellDelegate {
    
}

class PartenerTableViewCell: UITableViewCell {

    //MARK:- Properities
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    static let identifier = "PartenerTableViewCell"
    private var counter: Int = 0
    private var itemCount: Int = 0
    private var timer: Timer? = nil
    private var shouldExpand: Bool = false // first time timer toggle the cell still not init

    var parteners: [Partener] = [] {
        didSet {
            itemCount = parteners.count
            collectionView.reloadData()
            toggleTimer()
        }
    }
    
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configureCollectionView()
        configurePageControl()
        configureLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleTimer), name: NSNotification.Name("TOGGLE_TIMER"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "TOGGLE_TIMER"), object: nil)
        print("Cell deinit")
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
    @objc func toggleTimer() {
        if shouldExpand {
            if itemCount > 0 && timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 9, target: self, selector: #selector(self.slideShow), userInfo: nil, repeats: true)
                timer?.tolerance = 0.3
            }
        } else {
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
        shouldExpand = !shouldExpand
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - 10)
    }
}
