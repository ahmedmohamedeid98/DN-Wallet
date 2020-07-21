//
//  SideMenuVCs.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/8/20.
//  Copyright © 2020 DN. All rights reserved.
//
protocol sideMenuTimerDelegate {
    func stopTimer()
}


class SideMenuVC: UIViewController {

    //MARK:- Properities
    private lazy var auth: UserAuthProtocol = UserAuth()
    private var isInSafeMode: Bool = false
    var userInfo: AccountInfo?
    let bg: UIView = {
        let vw = UIView()
        vw.backgroundColor = .DnColor
        return vw
    }()
    
    let assistView: UIView = {
       let vw = UIView()
        vw.backgroundColor = .DnDarkBlue
        return vw
    }()
    let appLogo: UIImageView =  {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Dynamic-Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
   
    var serviceTable:UITableView!
    let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.left.square"), for: .normal)
        btn.setTitle(" Logout", for: .normal)
        btn.addTarget(self, action: #selector(logoutBtnWasPressed), for: .touchUpInside)
        btn.tintColor = .white
        return btn
    }()
    let settingButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "setting_white_24"), for: .normal)
        btn.setTitle("  Setting", for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(settingBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        isInSafeMode = auth.isAppInSafeMode
        view.backgroundColor = .DnVcBackgroundColor
        setupServiceTable()
        setupLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeSettingButton(isInSafeMode) // deactive setting button if the app in safeMode else otherwise.
        if isInSafeMode { serviceTable.reloadData() }
    }

    //MARK:- Handlers
    func setupServiceTable() {
        serviceTable = UITableView()
        serviceTable.delegate = self
        serviceTable.dataSource = self
        serviceTable.register(SideMenuCell.self, forCellReuseIdentifier: SideMenuCell.reuseIdentifier)
        serviceTable.rowHeight = 50
        serviceTable.separatorStyle = .none
        serviceTable.backgroundColor = .clear
    }
    func setupLayout() {
        view.addSubview(assistView)
        assistView.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,size: CGSize(width: 0, height: 90))
        view.addSubview(bg)
        bg.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 81))
   
        let topStack = UIStackView(arrangedSubviews: [appLogo, settingButton])
        topStack.configureStack(axis: .vertical, distribution: .fill, alignment: .center, space: 10)
        appLogo.DNLayoutConstraint(size: CGSize(width: 70, height: 70))
        bg.addSubview(topStack)
        bg.addSubview(serviceTable)
        bg.addSubview(logoutButton)
        let viewWidth = self.view.frame.width
        let stackWidth:CGFloat = 100.0
        let stackHeight:CGFloat = 120.0
        let leftDistance = (viewWidth - 81) / 2 - (stackWidth / 2.0)
        topStack.DNLayoutConstraint(bg.topAnchor , left: bg.leftAnchor, margins: UIEdgeInsets(top: 60, left: leftDistance, bottom: 0, right: 0), size: CGSize(width: stackWidth, height: stackHeight))

        serviceTable.DNLayoutConstraint(topStack.bottomAnchor, left: bg.leftAnchor, right: bg.rightAnchor, bottom: logoutButton.topAnchor, margins: UIEdgeInsets(top: 40, left: 16, bottom: 8, right: 4))
        logoutButton.DNLayoutConstraint(left: bg.leftAnchor, bottom: bg.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 0), size: CGSize(width: 80, height: 30))
    }
    
    func activeSettingButton(_ active: Bool) {
        if active {
            settingButton.setImage(UIImage(systemName: "lock.circle"), for: .normal)
            settingButton.isUserInteractionEnabled = false
        } else {
            settingButton.setImage(UIImage(named: "setting_white_24"), for: .normal)
            settingButton.isUserInteractionEnabled = true
        }
    }
    
    
    //MARK:- Handle Actions
    @objc func settingBtnPressed() {
        let settingvc = SettingVC()
        settingvc.userInfo = self.userInfo
        let vc = UINavigationController(rootViewController: settingvc)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func logoutBtnWasPressed() {
        auth.signOut() // delete token before logout
        self.dismiss(animated: true, completion: nil)
    }
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = serviceTable.dequeueReusableCell(withIdentifier: SideMenuCell.reuseIdentifier, for: indexPath) as? SideMenuCell else {return UITableViewCell()}
        guard let service = ServiceSection(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.inSafeMode = self.isInSafeMode
        cell.section = service
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInSafeMode {
            if let isSafe = ServiceSection(rawValue: indexPath.row)?.isSafe {
                if !isSafe { ServiceSection(rawValue: indexPath.row)?.pushVC(from: self) }
            }
        } else {
            ServiceSection(rawValue: indexPath.row)?.pushVC(from: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


