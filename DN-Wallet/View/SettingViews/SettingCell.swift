//
//  SettingCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/5/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    var sectionType : SectionType? {
        didSet{
            guard let sectionType = sectionType else {return}
            textLabel?.text = sectionType.description
            if !sectionType.containsSwitch {
                self.accessoryType = .disclosureIndicator
                if sectionType.description == "Language" {
                    addDescriptionLabel()
                    setLanguage()
                }
            } else {
                addSwitchToThisCell()
            }
        }
    }
    
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
        lb.textColor = .lightGray
        return lb
    }()
    
    var Switch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.onTintColor = UIColor.DN.DarkBlue.color()
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
            
        
    }
    
    func addSwitchToThisCell() {
        addSubview(Switch)
        Switch.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), centerV: true)
        Switch.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)
        self.selectionStyle = .none
    }
    
    func addDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.DNLayoutConstraint(right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25),size: CGSize(width: 60, height: 0), centerV: true)
    }
    
    @objc func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("switch on")
        } else {
            print("switch off")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
