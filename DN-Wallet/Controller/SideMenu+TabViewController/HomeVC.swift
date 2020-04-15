//
//  HomeVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

protocol HomeViewControllerDelegate: class {
    func handleSideMenuToggle()
}

class HomeVC: UIViewController {

    
    var balance: [Balance] = [Balance(amount: 245.54, currency: "USD"), Balance(amount: 24, currency: "EGP"), Balance(amount: 200, currency: "EUR"), Balance(amount: 245.0, currency: "KWD")]
    
    //MARK:- Properities
    var isExpand: Bool = false
    var leftBarButton: UIBarButtonItem!
    weak var delegate:HomeViewControllerDelegate?
    var collectioView: UICollectionView!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        handleNavigationBar()
        setupCollectionView() 
        addGestureRecognizer()
        setupLayout()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Handlers
    
    func handleNavigationBar() {
        let titleColor = UIColor.white
        let backgroundColor = UIColor.DN.DarkBlue.color()
        self.configureNavigationBar(largeTitleColor: titleColor, backgoundColor: backgroundColor, tintColor: titleColor, title: "Home", preferredLargeTitle: false)
        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideMenuButtonPressed))
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectioView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectioView.delegate = self
        collectioView.dataSource = self
        collectioView.backgroundColor = .white
        collectioView.register(HomeCurrencyCell.self, forCellWithReuseIdentifier: "homecurrencycell")
        collectioView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headercellid")
    }
    func setupLayout() {
        view.addSubview(collectioView)
        collectioView.DNLayoutConstraint(left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20), size: CGSize(width: 0, height: 250))
    }
    
    //MARK:- GestureRecognizer
    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeSideMenuWithGesture))
        let rightSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(sideMenuButtonPressed))
        let leftSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeSideMenuWithGesture))
        leftSwipGesture.direction = .left
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(rightSwipGesture)
        view.addGestureRecognizer(leftSwipGesture)
    }
    
    @objc func sideMenuButtonPressed() {
        delegate?.handleSideMenuToggle()
        isExpand = !isExpand
    }
    @objc func closeSideMenuWithGesture() {
        if isExpand {
            delegate?.handleSideMenuToggle()
            isExpand = !isExpand
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 8 , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return balance.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homecurrencycell", for: indexPath) as? HomeCurrencyCell else {return UICollectionViewCell() }
        cell.data = self.balance[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headercellid", for: indexPath) as? HeaderCell else {return UICollectionReusableView() }
            header.data = "The Balance"
            return header
        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
