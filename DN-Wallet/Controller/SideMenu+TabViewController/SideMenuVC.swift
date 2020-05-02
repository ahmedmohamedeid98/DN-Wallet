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
    let bg: UIView = {
        let vw = UIView()
        vw.backgroundColor = .DnDarkBlue
        return vw
    }()
    
    let assistView: UIView = {
       let vw = UIView()
        vw.backgroundColor = .DnDarkBlue
        return vw
    }()
    
    let userName: UILabel = {
        let lb = UILabel()
        lb.text = "username"
        lb.textColor = .white//UIColor.DN.Black.color()
        lb.font = UIFont.DN.Regular.font(size: 16)
        return lb
    }()
    
    let usernameIcon: UILabel = {
        let lb = UILabel()
        lb.text = "k"
        lb.backgroundColor = .white
        lb.textAlignment = .center
        lb.textColor = .systemPink//UIColor.DN.Black.color()
        lb.font = UIFont.DN.Regular.font(size: 16)
        lb.clipsToBounds = true
        lb.layer.cornerRadius = 10
        return lb
    }()
    
    let userEmail: UILabel = {
        let lb = UILabel()
        lb.text = "ahmedmohamedeid98@example.com"
        lb.textColor = .white//.lightGray
        lb.font = UIFont.DN.Regular.font(size: 16)
        return lb
    }()
    
    let mailIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "envelope")
        icon.tintColor = .white
        return icon
    }()
    
    var userAddress: UILabel = {
        let lb = UILabel()
        lb.text = "Cairo, ALd214"
        lb.textColor = .white//.lightGray
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    var userPhone: UILabel = {
        let lb = UILabel()
        lb.text = "01096584541"
        lb.textColor = .white//.lightGray
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
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
        btn.tintColor = .white//UIColor.DN.DarkBlue.color()
        btn.addTarget(self, action: #selector(settingBtnPressed), for: .touchUpInside)
        return btn
    }()
    let addressIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "place_white_24")
        //icon.tintColor = .white
        return icon
    }()
    let phoneIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "phone.fill")
        icon.tintColor = .white
        return icon
    }()
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupServiceTable()
        setupLayout()
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
        //bg.addSubview(userImage)
        bg.addSubview(usernameIcon)
        bg.addSubview(userName)
        bg.addSubview(mailIcon)
        bg.addSubview(userEmail)
        bg.addSubview(addressIcon)
        bg.addSubview(userAddress)
        bg.addSubview(phoneIcon)
        bg.addSubview(userPhone)
        bg.addSubview(settingButton)
        bg.addSubview(serviceTable)
        bg.addSubview(logoutButton)
        let leftDistance = (view.frame.size.width - 81) / 2 - 15
        settingButton.DNLayoutConstraint(bg.topAnchor, left: bg.leftAnchor, margins: UIEdgeInsets(top: 50, left: leftDistance, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        usernameIcon.DNLayoutConstraint(settingButton.bottomAnchor, left: bg.leftAnchor, margins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        userName.DNLayoutConstraint(usernameIcon.topAnchor, left: usernameIcon.rightAnchor, right: bg.rightAnchor, bottom: usernameIcon.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        mailIcon.DNLayoutConstraint(usernameIcon.bottomAnchor, left: usernameIcon.leftAnchor, margins: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        userEmail.DNLayoutConstraint(mailIcon.topAnchor, left: mailIcon.rightAnchor, right: bg.rightAnchor, bottom: mailIcon.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        addressIcon.DNLayoutConstraint(mailIcon.bottomAnchor, left: mailIcon.leftAnchor, margins: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        userAddress.DNLayoutConstraint(addressIcon.topAnchor, left: addressIcon.rightAnchor, right: bg.rightAnchor, bottom: addressIcon.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16))
        
        phoneIcon.DNLayoutConstraint(addressIcon.bottomAnchor, left: addressIcon.leftAnchor, margins: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0), size: CGSize(width: 20, height: 20))
        userPhone.DNLayoutConstraint(phoneIcon.topAnchor, left: phoneIcon.rightAnchor, right: bg.rightAnchor, bottom: phoneIcon.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 16))

        serviceTable.DNLayoutConstraint(phoneIcon.bottomAnchor, left: phoneIcon.leftAnchor, right: bg.rightAnchor, bottom: logoutButton.topAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 8, right: 4))
        logoutButton.DNLayoutConstraint(left: bg.leftAnchor, bottom: bg.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0), size: CGSize(width: 80, height: 30))
    }
    
    //MARK:- Handle Actions
    @objc func settingBtnPressed() {
        let settingvc = SettingVC()
        let vc = UINavigationController(rootViewController: settingvc)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func logoutBtnWasPressed() {
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
        cell.section = service
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ServiceSection(rawValue: indexPath.row)?.presentViewController(from: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    
}
