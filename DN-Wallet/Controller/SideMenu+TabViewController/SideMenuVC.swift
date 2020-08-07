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
    let assistView                  = UIView()
    let appLogo                     = DNAvatarImageView(frame: .zero)
    let logoutButton                = DNButton(backgroundColor: .clear, title: " Logout", systemTitle: "arrow.left.square")
    let settingButton               = DNButton(backgroundColor: .clear, title: " Setting", assetsTitle: "setting_white_24")
    private var isInSafeMode: Bool  = false
    var userInfo: AccountInfo?
    var serviceTable:UITableView!
    
    // network instance
    private lazy var auth: UserAuthProtocol = UserAuth()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor        = .DnColor
        assistView.backgroundColor  = .DnColor
        setupServiceTable()
        configureLogoImage()
        configureLogoutButton()
        configureSettingButton()
        setupLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isInSafeMode = auth.isAppInSafeMode
        activeSettingButton(isInSafeMode) // deactive setting button if the app in safeMode else otherwise.
        if isInSafeMode {
            _ = auth.checkIfAppOutTheSafeMode()
            serviceTable.reloadData() }
    }

    //MARK:- Handlers
    func setupServiceTable() {
        serviceTable                    = UITableView()
        serviceTable.delegate           = self
        serviceTable.dataSource         = self
        serviceTable.register(SideMenuCell.self, forCellReuseIdentifier: SideMenuCell.reuseIdentifier)
        serviceTable.rowHeight          = 50
        serviceTable.separatorStyle     = .none
        serviceTable.backgroundColor    = .clear
    }
    
    private func configureLogoImage() {
        appLogo.image                   = UIImage(named: "Dynamic-Logo")
    }
    
    private func configureLogoutButton() {
        logoutButton.titleLabel?.font   = UIFont.systemFont(ofSize: 16)
        logoutButton.withTarget         = {  self.logoutBtnWasPressed() }
    }
    
    private func configureSettingButton() {
        settingButton.titleLabel?.font  = UIFont.systemFont(ofSize: 16)
        settingButton.withTarget        = { self.settingBtnPressed() }
    }
    
    func setupLayout() {
        let topStack = UIStackView(arrangedSubviews: [appLogo, settingButton])
        view.addSubview(assistView)
        view.addSubview(topStack)
        view.addSubview(serviceTable)
        view.addSubview(logoutButton)
        
        assistView.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                      size: CGSize(width: 0, height: 90))
           
        topStack.configureStack(axis: .vertical, distribution: .fill, alignment: .center, space: 10)
        appLogo.DNLayoutConstraint(size: CGSize(width: 70, height: 70))
        let viewWidth = self.view.frame.width
        let stackWidth:CGFloat = 100.0
        let stackHeight:CGFloat = 120.0
        let leftDistance = (viewWidth - 81) / 2 - (stackWidth / 2.0)
        
        topStack.DNLayoutConstraint(view.topAnchor , left: view.leftAnchor,
                                    margins: UIEdgeInsets(top: 60, left: leftDistance, bottom: 0, right: 81),
                                    size: CGSize(width: stackWidth, height: stackHeight))

        serviceTable.DNLayoutConstraint(topStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                        bottom: logoutButton.topAnchor,
                                        margins: UIEdgeInsets(top: 40, left: 16, bottom: 8, right: 81))
        
        logoutButton.DNLayoutConstraint(left: view.leftAnchor, bottom: view.bottomAnchor,
                                        margins: UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 0),
                                        size: CGSize(width: 80, height: 30))
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
