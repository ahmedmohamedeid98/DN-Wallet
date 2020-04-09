//
//  SideMenuVCs.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/8/20.
//  Copyright © 2020 DN. All rights reserved.
//

class SideMenuVC: UIViewController {

    //MARK:- Properities
    let userImage: UIImageView = {
        let uImage = UIImageView()
        uImage.layer.cornerRadius = 20
        uImage.image = UIImage(systemName: "person.circle")
        uImage.backgroundColor = .orange
        uImage.tintColor = .white
        uImage.clipsToBounds = true
        uImage.contentMode = .scaleAspectFit
        return uImage
    }()
    
    let userName: UILabel = {
        let lb = UILabel()
        lb.text = "username"
        lb.textColor = UIColor.DN.Black.color()
        lb.font = UIFont.DN.Bold.font(size: 16)
        return lb
    }()
    
    let userEmail: UILabel = {
        let lb = UILabel()
        lb.text = "user@example.com"
        lb.textColor = .lightGray
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    
    var userAddress: UILabel = {
        let lb = UILabel()
        lb.text = "Cairo, ALd214"
        lb.textColor = .lightGray
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    var userPhone: UILabel = {
        let lb = UILabel()
        lb.text = "01096584541"
        lb.textColor = .lightGray
        lb.font = UIFont.DN.Regular.font(size: 14)
        return lb
    }()
    var serviceTable:UITableView!
    let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "dd"), for: .normal)
        btn.setTitle("Logout", for: .normal)
        return btn
    }()
    let settingButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        btn.backgroundColor = .orange
        btn.tintColor = UIColor.DN.DarkBlue.color()
        btn.addTarget(self, action: #selector(settingBtnPressed), for: .touchUpInside)
        return btn
    }()
    let addressIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "ss")
        return icon
    }()
    let phoneIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "phone.fill")
        return icon
    }()
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupServiceTable()
        setupLayout()
    }

    //MARK:- Handlers
    func setupServiceTable() {
        serviceTable = UITableView()
        serviceTable.delegate = self
        serviceTable.dataSource = self
        serviceTable.register(SideMenuCell.self, forCellReuseIdentifier: "servicecellid")
        serviceTable.rowHeight = 50
        serviceTable.separatorStyle = .none
    }
    func setupLayout() {
        view.addSubview(userImage)
        view.addSubview(userName)
        view.addSubview(userEmail)
        view.addSubview(settingButton)
        view.addSubview(serviceTable)
        view.addSubview(logoutButton)
        let addressStackView = UIStackView(arrangedSubviews: [addressIcon, userAddress])
        addressStackView.configureStack(axis: .horizontal, distribution: .fill, alignment: .fill, space: 8)
        addressIcon.DNLayoutConstraint(size: CGSize(width: 20, height: 0))
        let phoneStackView = UIStackView(arrangedSubviews: [phoneIcon, userPhone])
        phoneStackView.configureStack(axis: .horizontal, distribution: .fill, alignment: .fill, space: 8)
        phoneIcon.DNLayoutConstraint(size: CGSize(width: 20, height: 0))
        let Vstack = UIStackView(arrangedSubviews: [addressStackView, phoneStackView])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 2)
        view.addSubview(Vstack)
        
        userImage.DNLayoutConstraint(view.topAnchor, margins: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 40))
        userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40).isActive = true
        
        settingButton.DNLayoutConstraint(userImage.topAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100), size: CGSize(width: 30, height: 30))
        userName.DNLayoutConstraint(userImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 0))
        userEmail.DNLayoutConstraint(userName.bottomAnchor, left: userName.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0))
        Vstack.DNLayoutConstraint(userEmail.bottomAnchor, left: userName.leftAnchor, right: settingButton.rightAnchor, margins: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 42))
        serviceTable.DNLayoutConstraint(Vstack.bottomAnchor, left: Vstack.leftAnchor, right: settingButton.rightAnchor, bottom: logoutButton.topAnchor, margins: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        logoutButton.DNLayoutConstraint(left: view.leftAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0), size: CGSize(width: 60, height: 30))
    }
    
    //MARK:- Handle Actions
    @objc func settingBtnPressed() {
        let settingvc = SettingVC()
        let vc = UINavigationController(rootViewController: settingvc)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = serviceTable.dequeueReusableCell(withIdentifier: "servicecellid", for: indexPath) as? SideMenuCell else {return UITableViewCell()}
        guard let service = ServiceSection(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.configure(id: service.id, icon: service.image, title: service.description, sys: service.sysImage)
        print("cell")
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
        view.backgroundColor = UIColor.DN.LightGray.color()
        return view
    }
    
    
}
