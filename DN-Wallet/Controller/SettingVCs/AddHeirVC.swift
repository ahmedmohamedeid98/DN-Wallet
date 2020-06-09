//
//  AddHeirVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class AddHeirVC: UIViewController {

    //MARK:- Data
    var data = [Heirs]()
    
    let infoTextView: UITextView = {
        let txt = UITextView()
        txt.font = UIFont.DN.Regular.font(size: 14)
        txt.textAlignment = .center
        txt.textColor = .lightGray
        txt.backgroundColor = .clear
        txt.isEditable = false
        txt.text = "Wellcome, To Safe your money if any something bad happend for you, you should specify a heir and you allowed to add at most two heir, note that all your money withh transmit to your's heir if you do not access the app for 90 days."
        return txt
    }()
    
    let firstHeir: UITextField = {
        let txt = UITextField()
        txt.font = UIFont.DN.Regular.font(size: 14)
        txt.textColor = UIColor.systemBlue
        txt.placeholder = "Add first heir"
        txt.backgroundColor = .DnCellColor
        txt.leftViewMode = .always
        txt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        txt.stopSmartActions()
        txt.addBorder(color: UIColor.DnColor.cgColor)
        return txt
    }()
    
    let firstPrecentage: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.DN.Regular.font(size: 14)
        lb.textColor = .DnColor
        lb.text = "100 %"
        return lb
    }()
    
    let firstLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.DN.Regular.font(size: 14)
        lb.textColor = .DnColor
        lb.text = "first"
        return lb
    }()
    
    let secondHeir: UITextField = {
        let txt = UITextField()
        txt.font = UIFont.DN.Regular.font(size: 14)
        txt.textColor = UIColor.systemBlue
        txt.placeholder = "Add second heir"
        txt.backgroundColor = .DnCellColor
        txt.leftViewMode = .always
        txt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        txt.stopSmartActions()
        txt.addBorder(color: UIColor.DnColor.cgColor)
        return txt
    }()
    
    let secondPrecentage: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.DN.Regular.font(size: 16)
        lb.textColor = .DnDarkBlue
        lb.text = "0 %"
        return lb
    }()
    
    let secondLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.DN.Regular.font(size: 14)
        lb.textColor = .DnDarkBlue
        lb.text = "second"
        return lb
    }()
    
    var sliderStack: UIStackView!
    var slider: UISlider!
    var rightBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        DNData.getUserHeirs(onView: view) { (heirs, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                self.data = heirs
            }
        }
        rightBarBtn = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(UpdateBtnPressed))
        rightBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        setupSlider()
        setupLayout()
        
        if data.count > 0 {
            let currentValue = Int(data[0].precent)
            self.firstPrecentage.text = "\(currentValue) %"
            self.secondPrecentage.text = "\(100 - currentValue) %"
        }
        
        
       
    }
    @objc func UpdateBtnPressed() {
        // call a API Data function which post new updates
    }
    func setupSlider() {
        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = data.count > 0 ? data[0].precent : 100
        slider.minimumTrackTintColor = .DnColor
        slider.maximumTrackTintColor = .DnDarkBlue
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    @objc func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        self.firstPrecentage.text = "\(currentValue) %"
        self.secondPrecentage.text = "\(100 - currentValue) %"
        rightBarBtn.isEnabled = true
    }
    func setupLayout() {
        view.addSubview(infoTextView)
        infoTextView.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, margins: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 120))
        
        sliderStack = UIStackView(arrangedSubviews: [firstLabel, firstPrecentage, slider, secondPrecentage, secondLabel])
        sliderStack.configureStack(axis: .horizontal, distribution: .fill, alignment: .fill, space: 8)
        slider.DNLayoutConstraint(size: CGSize(width: 150, height: 0))
        
        let Vstack = UIStackView(arrangedSubviews: [firstHeir, sliderStack, secondHeir])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 10)
        view.addSubview(Vstack)
        Vstack.DNLayoutConstraint(infoTextView.bottomAnchor, left: infoTextView.leftAnchor, right: infoTextView.rightAnchor, margins: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 140))
        
    }
    

}



























