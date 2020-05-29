//
//  SettingCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    // MARK:- Safe Mode Delegates
    weak var safeModeAlertDelegate: SafeModeAlert!
    weak var safeModeDelegate: SafeModeProtocol!
    
    // MARK:- Setting Cell's Datasource
    var sectionType : SectionType? {
        didSet{
            guard let sectionType = sectionType else {return}
            textLabel?.text = sectionType.description
            if !sectionType.containsSwitch {
                self.accessoryType = .disclosureIndicator
                if sectionType.description == GeneralOptions.language.description  {
                    addDescriptionLabel()
                    setLanguage()
                }
                if sectionType.description == SecurityOptions.safeModeTime.description {
                    addDescriptionLabel()
                    //setTime()
                }
            } else {
                addSwitchToThisCellWith(tag: sectionType.id)
            }
        }
    }
    /*
    func setTime() {
        descriptionLabel.text = "\(Auth.shared.getSafeModeTime()) hour"
    }
    */
    func setLanguage() {
        let languageID =  UserDefaults.standard.integer(forKey: Defaults.Language.key)
        for lang in LanguageSection.allCases {
            if lang.rawValue == languageID {
                descriptionLabel.text = lang.description
            }
        }
    }
    
    var descriptionLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.DN.Light.font(size: 14)
        lb.textColor = .gray
        lb.textAlignment = .right
        return lb
    }()
    
    var Switch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .DnColor
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
            
        
    }
    
    func addSwitchToThisCellWith(tag: Int) {
        addSubview(Switch)
        Switch.tag = tag
        if tag == SecurityOptions.safeMode.id {
            Switch.isOn = UserDefaults.standard.bool(forKey: Defaults.EnableSafeMode.key)
        }
        if tag == SecurityOptions.enableLoginWithFaceID.id {
            Switch.isOn = UserDefaults.standard.bool(forKey: Defaults.LoginWithBiometric.key)
        }
        Switch.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), centerV: true)
        Switch.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)
        self.selectionStyle = .none
    }
    
    func addDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 35),size: CGSize(width: 60, height: 0), centerV: true)
    }
    
    @objc func toggleSwitch(_ sender: UISwitch) {
        if sender.tag == SecurityOptions.safeMode.id {
            if sender.isOn {
                safeModeAlertDelegate.showSafeModeAlert { (accept) in
                    if accept {
                        self.safeModeDelegate.activeSafeMode()
                    }else {
                        sender.isOn = false
                    }
                }
            } else {
                safeModeDelegate.disableSafeMode()
            }
        }
        if sender.tag == SecurityOptions.enableLoginWithFaceID.id {
            UserDefaults.standard.set(sender.isOn, forKey: Defaults.LoginWithBiometric.key)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
