//
//  SettingCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    //MARK:- Properities
    var descriptionLabel    = DNTitleLabel(title: " ", alignment: .right, fontSize: 14, weight: .light)
    var Switch: UISwitch    = {
        let sw = UISwitch()
        sw.onTintColor = .DnColor
        return sw
    }()
    
   
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .DnCellColor
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
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
                       setTime()
                   }
               } else {
                   addSwitchToThisCellWith(tag: sectionType.id)
               }
           }
       }
       
    
    //MARK:- Methods
    func setTime() {
        descriptionLabel.text = "\(AuthManager.shared.getSafeModeTime()) hour"
    }
    
    func setLanguage() {
        let languageID =  UserPreference.getIntValue(withKey: UserPreference.languageKey)
        for lang in LanguageSection.allCases {
            if lang.rawValue == languageID {
                descriptionLabel.text = lang.description
            }
        }
    }
    
    
    func addSwitchToThisCellWith(tag: Int) {
        addSubview(Switch)
        Switch.tag = tag
        if tag == SecurityOptions.safeMode.id {
            Switch.isOn = UserPreference.getBoolValue(withKey: UserPreference.enableSafeMode)
        }
        if tag == SecurityOptions.enableLoginWithFaceID.id {
            Switch.isOn = UserPreference.getBoolValue(withKey: UserPreference.loginWithBiometric)
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
                AuthManager.shared.activeSafeMode()
            } else {
                AuthManager.shared.deactiveSafeMode()
            }
        }
        if sender.tag == SecurityOptions.enableLoginWithFaceID.id {
            UserPreference.setValue(sender.isOn, withKey: UserPreference.loginWithBiometric)
        }
    }
    
   
    
}
