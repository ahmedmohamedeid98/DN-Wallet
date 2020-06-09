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

// use to config CollectionViewDiffableDataSource
enum Section: CaseIterable {
    case main
}

class HomeVC: UIViewController {
    
    // Data
    var balance: [Balance] = [Balance(amount: 245552.54, currency: "USD"), Balance(amount: 24, currency: "EGP"), Balance(amount: 200, currency: "EUR"), Balance(amount: 245.0, currency: "KWD")]
    var imagesNames = ["test_image1", "test_image2", "test_image3", "test_image4"]
    //MARK:- Utilities
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    //MARK:- viewController Properities
    var imageCount: Int = 0
    var isExpand: Bool = false
    var leftBarButton: UIBarButtonItem!
    weak var delegate:HomeViewControllerDelegate?
    
    //MARK:- Data Will send to another vc
    var notificationMessages: [Message] = []
    
    //MARK:- CollectionView Properities
    var balanceCollectioView: UICollectionView!
    var sliderCollectionView: UICollectionView!
    var balanceDataSource: UICollectionViewDiffableDataSource<Section, Balance>! = nil
    var sliderDataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var counter: Int = 0
    var pageControl: UIPageControl!
    let goRightButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1022848887)
        btn.setImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(goRightAction), for: .touchUpInside)
        return btn
    }()
    let goLeftButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1022848887)
        btn.setImage(UIImage(systemName: "chevron.compact.left"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(goLeftAction), for: .touchUpInside)
        return btn
    }()
    var timer: Timer!
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        initViewController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .DnVcBackgroundColor
        startTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    func startTimer() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(self.slideShow), userInfo: nil, repeats: true)
        }
    }
    func stopTimer() {
        self.timer.invalidate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Handlers
    func initViewController() {
        print("{\ntoken: \(Auth.shared.getUserToken())\n}")
        Auth.shared.deactiveSafeMode()
        counter = 0
        pageControl = UIPageControl()
        imageCount = imagesNames.count
        pageControl.numberOfPages = imageCount
        pageControl.currentPageIndicatorTintColor = .white
        //Setup Layout
        handleNavigationBar()
        setupSliderCollectionView()
        setupBalanceCollectionView()
        setupLayout()
        // Slider Collection View
        configureSliderDataSource()
        sliderCollectionView.dataSource = sliderDataSource
        // Balance Collection View
        configureBalanceDataSource()
        balanceCollectioView.dataSource = balanceDataSource
        
        addGestureRecognizer()
        
        // Fetch Notifications Messages
        fetchNotificationMessages()
    }
    
    
    @objc func slideShow() {
        if counter < imageCount {
            slideToItemAt(counter)
            counter += 1
        }else {
            counter = 0
            slideToItemAt(counter, animate: false)
            counter = 1
        }
    }
    
    func slideToItemAt(_ counter: Int, animate: Bool = true) {
        let index = IndexPath(item: counter, section: 0)
        self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animate)
        pageControl.currentPage = counter
    }
    
    private func handleNavigationBar() {
        self.configureNavigationBar(title: "Home", preferredLargeTitle: false)
        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideMenuButtonPressed))
        navigationItem.leftBarButtonItem = leftBarButton
        addRightBarButtonWithImage(name: "envelope")
        
    }
    
    private func thereIsNewMessages() {
        addRightBarButtonWithImage(name: "envelope.badge")
    }
    
    private func addRightBarButtonWithImage(name: String) {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: name), style: .plain, target: self, action: #selector(notificationBtnPressed))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    @objc func notificationBtnPressed() {
        let vc = NotificationVC()
        vc.originalData = notificationMessages
        self.present(vc, animated: true, completion: nil)
    }
    private func setupLayout() {
        view.addSubview(sliderCollectionView)
        view.addSubview(goRightButton)
        view.addSubview(goLeftButton)
        view.addSubview(pageControl)
        view.addSubview(balanceCollectioView)
        sliderCollectionView.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 250))
        goLeftButton.DNLayoutConstraint(left: sliderCollectionView.leftAnchor, bottom: sliderCollectionView.bottomAnchor, size: CGSize(width: 30, height: 200))
        goRightButton.DNLayoutConstraint(right: sliderCollectionView.rightAnchor, bottom: sliderCollectionView.bottomAnchor, size: CGSize(width: 30, height: 200))
        pageControl.DNLayoutConstraint(left: view.leftAnchor, right: view.rightAnchor, bottom: sliderCollectionView.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20) , size: CGSize(width: 0, height: 20))
        
        balanceCollectioView.DNLayoutConstraint(sliderCollectionView.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 40, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 250))
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
        if isExpand {
            stopTimer()
        }else {
            startTimer()
        }
    }
    @objc func closeSideMenuWithGesture() {
        if isExpand {
            delegate?.handleSideMenuToggle()
            isExpand = !isExpand
            startTimer()
        }
    }
    
    
    @objc func goRightAction() {
        if counter < imageCount {
            slideToItemAt(counter, animate: true)
            counter += 1
        }else {
            counter = 0
            slideToItemAt(counter, animate: false)
            counter = 1
        }
        
    }
    @objc func goLeftAction() {
        if counter > 0 {
            slideToItemAt(counter, animate: true)
            counter -= 1
        }else {
            counter = imageCount - 1
            slideToItemAt(counter, animate: true)
            counter = imageCount
        }
    }
}

//MARK:- Setup Slider Collection View
extension HomeVC {
    
    
    func setupSliderCollectionView() {
        sliderCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createSliderLayout())
        sliderCollectionView.backgroundColor = .clear
        sliderCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: SliderCell.reuseIdentifier)
        sliderCollectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: HomeVC.sectionHeaderElementKind, withReuseIdentifier: CollectionViewHeader.reuseIdentifier)
    }
    
    private func createSliderLayout() -> UICollectionViewLayout {
        //1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        //2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //3
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // add header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeVC.sectionHeaderElementKind, alignment: .top)
        headerElement.pinToVisibleBounds = true
        //headerElement.zIndex = 2
        section.boundarySupplementaryItems = [headerElement]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureSliderDataSource() {
        // populate cell
        sliderDataSource = UICollectionViewDiffableDataSource(collectionView: sliderCollectionView, cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: SliderCell.reuseIdentifier, for: indexPath) as? SliderCell else {fatalError("can not dequeue slider cell")}
            cell.data = data
            return cell
        })
        sliderDataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.reuseIdentifier, for: indexPath) as? CollectionViewHeader else {fatalError("can not dequeue header for sliderCollection")}
            header.data = "Partners"
            header.backgroundColor = .clear
            return header
        }
        // init cell
        var snapShot = NSDiffableDataSourceSnapshot<Section, String>()
        snapShot.appendSections(Section.allCases)
        imagesNames.forEach { snapShot.appendItems([$0], toSection: .main) }
        sliderDataSource.apply(snapShot, animatingDifferences: true)
    }
    
    
}

//MARK:- Setup Balance Collection View
extension HomeVC {
    func setupBalanceCollectionView() {
        balanceCollectioView = UICollectionView(frame: .zero, collectionViewLayout: createBalanceLayout())
        balanceCollectioView.backgroundColor = .clear
        balanceCollectioView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.reuseIdentifier)
        balanceCollectioView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: HomeVC.sectionHeaderElementKind, withReuseIdentifier: CollectionViewHeader.reuseIdentifier)
    }
    
    private func createBalanceLayout() -> UICollectionViewLayout {
        //1
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        //2
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        //3
        let section = NSCollectionLayoutSection(group: group)
        //header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HomeVC.sectionHeaderElementKind, alignment: .top)
        headerElement.pinToVisibleBounds = true
        //headerElement.zIndex = 2 // ???
        section.boundarySupplementaryItems = [headerElement]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureBalanceDataSource() {
        // populate cell
        balanceDataSource = UICollectionViewDiffableDataSource(collectionView: balanceCollectioView, cellProvider: { (collection, indexPath, data) -> UICollectionViewCell? in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier: CurrencyCell.reuseIdentifier , for: indexPath) as? CurrencyCell else {fatalError("can not dequeue balance cell")}
            cell.data = data
            return cell
        })
        balanceDataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.reuseIdentifier, for: indexPath) as? CollectionViewHeader else {fatalError("can not dequeue balance header")}
            header.data = "Balance"
            header.backgroundColor = .clear
            return header
        }
        // init cell
        var snapShot = NSDiffableDataSourceSnapshot<Section, Balance>()
        snapShot.appendSections(Section.allCases)
        balance.forEach{ snapShot.appendItems([$0], toSection: .main) }
        balanceDataSource.apply(snapShot, animatingDifferences: true)
    }
    
}
//MARK:- Networks (API)
extension HomeVC {
    private func fetchNotificationMessages() {
        self.notificationMessages = Message.fetchMessages()
        guard let topMessage = notificationMessages.first else {return}
        if topMessage.isnew {
            thereIsNewMessages()
        }
    }
}
