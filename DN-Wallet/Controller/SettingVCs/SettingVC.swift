//
//  SettingVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit
import MBProgressHUD


class SettingVC: UIViewController {

    private lazy var auth: UserAuthProtocol = UserAuth()
    var settingTable: UITableView!
    var userQuikDetails: UserQuikDetails!
    var leftBarButton: UIBarButtonItem!
    var userInfo: AccountInfo?
    private lazy var meManager: MeManagerProtocol = MeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        //loadData()
        setupNavBar()
        setupUserQuikDetailsView()
        setupTableView()
        setupLayout()
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
   
    func setupNavBar() {
        self.configureNavigationBar(title: "Setting", preferredLargeTitle: true)
        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(closeButtonPressed))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupUserQuikDetailsView() {
        userQuikDetails = UserQuikDetails()
        userQuikDetails.userName.text = "username"
        userQuikDetails.userEmail.text = "example@gmail.com"
    }
    
    func setupTableView() {
        settingTable = UITableView()
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.backgroundColor = .clear
        settingTable.register(SettingCell.self, forCellReuseIdentifier: "settingcellid")
        settingTable.rowHeight = 60
    }

    func setupLayout() {
        view.addSubview(settingTable)
        settingTable.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func pushViewController(_ vc: UIViewController, title: String, styleFull: Bool){
        if styleFull { vc.modalPresentationStyle = .fullScreen }
        vc.title = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingSection(rawValue: section) else {return 0}
        switch section {
        case .General : return GeneralOptions.allCases.count
        case .Security: return SecurityOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTable.dequeueReusableCell(withIdentifier: "settingcellid", for: indexPath) as? SettingCell else {return UITableViewCell()}

        guard let section = SettingSection(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .General : cell.sectionType = GeneralOptions(rawValue: indexPath.row)
        case .Security: cell.sectionType = SecurityOptions(rawValue: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title = UILabel()
        view.backgroundColor = .DnColor
        title.font = UIFont.DN.Regular.font(size: 16)
        title.textColor = .white
        title.text = SettingSection(rawValue: section)?.description
        view.addSubview(title)
        if section == 0 {
            view.addSubview(userQuikDetails)
            userQuikDetails.DNLayoutConstraint(view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, size: CGSize(width: 0, height: 80))
            title.DNLayoutConstraint(userQuikDetails.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, margins: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        } else {
            title.translatesAutoresizingMaskIntoConstraints = false
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        }
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = tableView.cellForRow(at: indexPath)?.textLabel?.text else {return}
        if indexPath.section == 0 {
            if title == GeneralOptions.editProfile.description {
                let st = UIStoryboard(name: "Services", bundle: .main)
                let vc = st.instantiateViewController(identifier: "editAccountVCID") as? EditAccountVC
                vc!.userInfo = self.userInfo
                pushViewController(vc!, title: title, styleFull: true)
            }
            if title ==  GeneralOptions.privacy.description {
                let vc = PrivacyVC()
                pushViewController(vc, title: title, styleFull: true)
            }
            if title == GeneralOptions.language.description {
                showLanguageActionSheet()
            }
        } else {
            if title == SecurityOptions.password.description {
                let vc = ChangePasswordVC()
                pushViewController(vc, title: "Change Password", styleFull: true)
            }
            if title == SecurityOptions.safeModeTime.description {
                setSafeModeTimeAlert()
            }
            if title == SecurityOptions.hair.description {
                let vc = AddHeirVC()
                pushViewController(vc, title: "Add Heir", styleFull: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        }
        return 40
    }
    
    
    
}

extension SettingVC {
    
    func showLanguageActionSheet() {
        let alert = UIAlertController(title: "Choose Language", message: "select your prefere language", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let English = UIAlertAction(title: LanguageSection.English.description , style: .default) { (action) in
            //UserDefaults.standard.set(LanguageSection.English.id, forKey: Defaults.Language.key)
            UserPreference.setValue(LanguageSection.English.id, withKey: UserPreference.languageKey)
            self.settingTable.updateRowWith(indexPaths: [GeneralOptions.language.indexPath], animate: .fade)
        }
        let Arabic = UIAlertAction(title: LanguageSection.Arabic.description , style: .default) { (action) in
            //UserDefaults.standard.set(LanguageSection.Arabic.id, forKey: Defaults.Language.key)
            UserPreference.setValue(LanguageSection.Arabic.id, withKey: UserPreference.languageKey)
            self.settingTable.updateRowWith(indexPaths: [GeneralOptions.language.indexPath], animate: .fade)
        }
        alert.addAction(English)
        alert.addAction(Arabic)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setSafeModeTimeAlert() {
        let alert = UIAlertController(title: "Safe Mode Time", message: "Set safe mode time in (Hours) , we recommend you that time be at least 12 hours.", preferredStyle: .alert)
        let setAction = UIAlertAction(title: "Set", style: .default) { (action) in
            if let hours = alert.textFields![0].text {
                self.auth.setSafeModeTime(hours: hours)
                self.settingTable.updateRowWith(indexPaths: [SecurityOptions.safeModeTime.indexPath], animate: .fade)
            }
        }
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (txt) in
            txt.font = UIFont.DN.Regular.font(size: 16)
            txt.stopSmartActions()
            txt.keyboardType = .numberPad
            txt.placeholder = "e.g: 12"
        }
        
        alert.addAction(Cancel)
        alert.addAction(setAction)
        present(alert, animated: true, completion: nil)
    }
    func showSafeModeAlert(completion: @escaping (Bool) -> ()) {
            
            let alert = UIAlertController(title: "By Activate \"Safe Mode\" You Accept to Stop Some Service For Specific Time.", message: "Send Money, Send Request, Withdraw Money will be Stopped. Pay From Purchases Will be Limited.", preferredStyle: .alert)
            let Cancle = UIAlertAction(title: "Cancle", style: .cancel) { (action) in
                completion(false)
            }
            let Continue = UIAlertAction(title: "Continue", style: .default) { (action) in
                completion(true)
            }
            
            alert.addAction(Cancle)
            alert.addAction(Continue)
            self.present(alert, animated: true, completion: nil)
    }
}

extension UINavigationController {

   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
//MARK:- Networking
extension SettingVC {
    
    //let center = NotificationCenter.default
    private func loadData() {
        // get user data
        meManager.getMyAccountInfo { (result) in
            switch result {
                case .success(let info):
                    self.handleGetUserInfoSuccessCase(withData: info)
                case .failure(_):
                    break
            }
        }
    }
    
    private func handleGetUserInfoSuccessCase(withData data: AccountInfo) {
        self.userInfo = data
        DispatchQueue.main.async {
            self.userQuikDetails.userName.text  =   data.user.name
            self.userQuikDetails.userEmail.text =   data.user.email
        }
        loadImage(withURL: data.user.photo)
    }
    
    private func handleGetUserInfoFailureCase(withError error: String) {
        // handel if getting data is faild
    }
    
    
    private func loadImage(withURL: String?) {
        if let imageUrl = withURL {
            ImageLoader.shared.loadImageWithStrURL(str: imageUrl) { (result) in
                switch result {
                    case .success(let img):
                        DispatchQueue.main.async { self.userQuikDetails.userImage.image = img }
                    case .failure(_):
                        break
                }
            }
        }
    }

}
