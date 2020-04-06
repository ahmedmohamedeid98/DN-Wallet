//
//  SettingCell.swift
//  DN-Wallet
//
//  Created by Mac OS on 4/5/20.
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
            } else {
                addSwitchToThisCell()
            }
            
            
        }
    }
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
