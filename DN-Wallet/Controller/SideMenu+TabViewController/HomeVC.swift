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
    
    // Data TEST
    var balance: [Balance] = [Balance(id: "sd", amount: 2500.0, currency: "USD"), Balance(id: "sd", amount: 240.00, currency: "EGP"), Balance(id: "sd", amount: 200.00, currency: "EUR"), Balance(id: "sd", amount: 245.00, currency: "KWD")]
    var parteners: [Partener] = [
        Partener(imageName: "test_image1", title: "Uber"),
        Partener(imageName: "test_image2", title: "Makdonse"),
        Partener(imageName: "test_image3", title: "Karfoure"),
        Partener(imageName: "test_image4", title: "Kareem")
    ]

    //MARK:- Properities
    var isExpand: Bool = false
    private var leftBarButton: UIBarButtonItem!
    private var partenerCell: PartenerTableViewCell!
    weak var delegate:HomeViewControllerDelegate?
    // Data Will send to notification view controller
    var notificationMessages: [Message] = []
    private var tableView: UITableView!
    private lazy var meManager: MeManagerProtocol = MeManager()
    private lazy var verifyManager: VerifyManagerProtocol = VerifyManager()
   
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        initViewController()
        checkAccountActiveStatus()
        //loadData()
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
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Methods
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(PartenerTableViewCell.self, forCellReuseIdentifier: PartenerTableViewCell.identifier)
        tableView.register(BalanceTableViewCell.self, forCellReuseIdentifier: BalanceTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
    }

    private func initViewController() {
        configureNavgationBar()
        setupTableView()
        setupLayout()
        addGestureRecognizer()
        // Fetch Notifications Messages
        fetchNotificationMessages()
    }
    
    // Configure Navigation Bar
    private func configureNavgationBar() {
        self.configureNavigationBar(title: "Home", preferredLargeTitle: false)
        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(sideMenuButtonPressed))
        navigationItem.leftBarButtonItem = leftBarButton
        addRightBarButtonWithImage(name: "envelope")
    }
    
    private func addRightBarButtonWithImage(name: String) {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: name), style: .plain, target: self, action: #selector(notificationBtnPressed))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func thereIsNewMessages() {
        addRightBarButtonWithImage(name: "envelope.badge")
    }
    
    @objc private func notificationBtnPressed() {
        let vc = NotificationVC()
        vc.originalData = notificationMessages
        self.present(vc, animated: true, completion: nil)
    }
    
    // add subviews
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    private func startTimer() {
        if let cell = partenerCell {
            cell.startTimer()
        }
    }
    
    private func stopTimer() {
        if let cell = partenerCell {
            cell.stopTimer()
        }
    }
    
    
}

//MARK:- handle sideMenu Toggle
extension HomeVC {

    private func addGestureRecognizer() {
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
}

//MARK:- Table view Delegate & Datasource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // init Partener Cell
        if indexPath.section == 0 {
            partenerCell = tableView.dequeueReusableCell(withIdentifier: PartenerTableViewCell.identifier, for: indexPath) as? PartenerTableViewCell
            if let cell = partenerCell {
                cell.parteners = parteners
                cell.startTimer()
                return cell
            }
            return UITableViewCell()
        }
        // init Balance Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BalanceTableViewCell.identifier , for: indexPath) as? BalanceTableViewCell else { return UITableViewCell() }
        cell.balances = balance
        return cell
    }
    
    // handle sections header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UIView()
        var title = "Balance"
        if section == 0 {
            title = "Parteners"
        }
        self.prepareView(for: header, withTitle: title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    private func prepareView(for header: UIView, withTitle title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .DnTextColor
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "KohinoorBangla-regular", size: 17) ?? UIFont.boldSystemFont(ofSize: 18)
        header.addSubview(titleLabel)
        titleLabel.DNLayoutConstraint(header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    
}

//MARK:- Networking
extension HomeVC {
    
    // Notification
    private func fetchNotificationMessages() {
        self.notificationMessages = Message.fetchMessages()
        guard let topMessage = notificationMessages.first else {return}
        if topMessage.isnew {
            thereIsNewMessages()
        }
    }
    
    
    private func loadUserBalances() {
        // ...
    }
    
    private func handleGetUserBalanceSuccessCase(withData data: AccountInfo) {
        
        // ...
    }
    
    private func handleGetUserBalanceFailureCase(withError error: String) {
        // ...
    }
    
    private func checkAccountActiveStatus() {
        verifyManager.checkAcountActiveStatus { (result) in
            switch result {
                case .success(let response):
                    self.checkIfUserNotVerified(isVerified: response.accountIsActive)
                case .failure(_):
                    break
            }
        }
    }
    
    private func checkIfUserNotVerified(isVerified: Bool = false) {
        if isVerified {
            print("Account is verified :)")
            return
        }
        print("Account is not verified :(")
        DispatchQueue.main.async {
            let st = UIStoryboard(name: "Authentication", bundle: nil)
            let confirmationViewController = st.instantiateViewController(identifier: "ConfirmEmailVCID") as? ConfirmEmailVC
            confirmationViewController?.modalPresentationStyle = .fullScreen
            self.present(confirmationViewController!, animated: true, completion: nil)
        }
    }
}
