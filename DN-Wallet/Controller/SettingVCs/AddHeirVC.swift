//
//  AddHeirVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 4/7/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class AddHeirVC: UIViewController {

    //MARK:- Properities
    var data = [getHeir]()
    private let infoTextView        = DNTextView(text: K.vc.heirMessage, alignment: .center, fontSize: 14, editable: false)
    private let firstHeir           = DNTextField(placeholder: "Add first heir")
    private let firstPrecentage     = DNTitleLabel(textAlignment: .center, fontSize: 14)
    private let firstLabel          = DNTitleLabel(textAlignment: .left, fontSize: 14)
    private let secondHeir          = DNTextField(placeholder: "Add second heir")
    private let secondPrecentage    = DNTitleLabel(textAlignment: .center, fontSize: 14)
    private let secondLabel         = DNTitleLabel(textAlignment: .right, fontSize: 14)
    private var sliderStack: UIStackView!
    private var slider: UISlider!
    private var rightBarBtn: UIBarButtonItem!
    private lazy var me :MeManagerProtocol = MeManager()
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        rightBarBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(UpdateBtnPressed))
        rightBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        setupSlider()
        setupLayout()
        
        if data.count > 0 {
            let currentValue = data[0].heir1Precentage
            self.firstPrecentage.text = "\(currentValue) %"
            self.secondPrecentage.text = "\(100 - currentValue) %"
        }
        configureFirstHierTextField()
        configureSecondHeirTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    //handle status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    //MARK:- Configure views
    @objc func UpdateBtnPressed() {
        if data.count == 0 {
            addHier()
        } else {
            updateHeirs()
        }
    }
    
    private func configureSecondHeirTextField() {
        secondPrecentage.text       = "0 %"
        secondPrecentage.textColor  = .systemPink
        
        secondLabel.text            = "Second"
        secondLabel.textColor       = .systemPink
        
        secondHeir.textColor        = .systemPink
        secondHeir.leftViewMode     = .always
        secondHeir.leftView         = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        secondHeir.backgroundColor  = .DnCellColor
        secondHeir.addBorder(color: UIColor.systemPink.cgColor, width: 2, withCornerRaduis: true, reduis: 4)
    }
    private func configureFirstHierTextField() {
        firstPrecentage.text        = "100 %"
        firstPrecentage.textColor   = .DnColor
        
        firstLabel.text             = "First"
        firstLabel.textColor        = .DnColor
        
        firstHeir.textColor         = .DnColor
        firstHeir.leftViewMode      = .always
        firstHeir.leftView          = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        firstHeir.backgroundColor   = .DnCellColor
        firstHeir.addBorder(color: UIColor.DnColor.cgColor, width: 2, withCornerRaduis: true, reduis: 4)
    }
    func setupSlider() {
        slider                          = UISlider()
        slider.minimumValue             = 0
        slider.maximumValue             = 100
        slider.value                    = 0
        slider.minimumTrackTintColor    = .DnColor
        slider.maximumTrackTintColor    = .DnDarkBlue
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    @objc func sliderValueChanged(_ sender: UISlider) {
        let currentValue            = Int(sender.value)
        self.firstPrecentage.text   = "\(currentValue) %"
        self.secondPrecentage.text  = "\(100 - currentValue) %"
        rightBarBtn.isEnabled       = true
    }
    func setupLayout() {
        view.addSubview(infoTextView)
        infoTextView.DNLayoutConstraint(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                        right: view.rightAnchor,
                                        margins: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
                                        size: CGSize(width: 0, height: 120))
        
        sliderStack = UIStackView(arrangedSubviews: [firstLabel, firstPrecentage, slider, secondPrecentage, secondLabel])
        sliderStack.configureStack(axis: .horizontal, distribution: .fill, alignment: .fill, space: 8)
        
        let Vstack = UIStackView(arrangedSubviews: [firstHeir, sliderStack, secondHeir])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 10)
        view.addSubview(Vstack)
        Vstack.DNLayoutConstraint(infoTextView.bottomAnchor, left: view.leftAnchor,
                                  right: view.rightAnchor,
                                  margins: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20),
                                  size: CGSize(width: 0, height: 140))
        
    }
}
//MARK:- Networking
extension AddHeirVC {
    private func loadData() {
        Hud.showLoadingHud(onView: view, withLabel: "Get Heirs...")
        me.getMyHeirs { result in
            Hud.hide(after: 0)
            switch result {
                case .success(let res): self.configureSuccessCase(data: res)
                case .failure(let err): self.configureGeneralFailureCase(msg: err.localizedDescription)
            }
        }
    }
    
    private func addHier() {
        guard validInput() else { return }
        print("after validate....add")
        Hud.showLoadingHud(onView: view, withLabel: "Adding...")
        me.addHeir(heir: PostHeir(first_heir: firstHeir.text!, second_heir: secondHeir.text!, precentage: Int(slider.value))) { result in
            Hud.hide(after: 0)
            switch result {
                case .success(let res): self.configureGeneralSuccessCase(msg: res.success)
                case .failure(let err): self.configureGeneralFailureCase(msg: err.localizedDescription)
            }
        }

    }
    
    private func updateHeirs() {
        guard validInput() else { return }
        print("after validate....update")
        Hud.showLoadingHud(onView: view, withLabel: "Updating...")
        me.updateHeir(heir: PostHeir(first_heir: firstHeir.text!, second_heir: secondHeir.text!, precentage: Int(slider.value))) { result in
            Hud.hide(after: 0)
            switch result {
                case .success(let res): self.configureGeneralSuccessCase(msg: res.success)
                case .failure(let err): self.configureGeneralFailureCase(msg: err.localizedDescription)
            }
        }
    }
    
    func validInput() -> Bool {
        guard let first = firstHeir.text, !first.isEmpty else {
            presentAlertOnTheMainThread(title: "Required", Message: "Adding first heir is required. Try again")
            return false
        }
        
        guard let second = secondHeir.text, !second.isEmpty else {
            presentAlertOnTheMainThread(title: "Required", Message: "Adding second heir is required. Try again")
            return false
        }
        
        return true
    }
    
    private func configureSuccessCase(data: [getHeir]) {
        self.data = data
        guard let safeData = data.first else { return }
        DispatchQueue.main.async {
            self.firstHeir.text         = safeData.heir1
            self.secondHeir.text        = safeData.heir2
            self.slider.value           = Float(safeData.heir1Precentage)
            self.firstPrecentage.text   = "\(safeData.heir1Precentage)"
            self.secondPrecentage.text  = "\(100 - safeData.heir1Precentage)"
        }
    }
    
    private func configureGeneralSuccessCase(msg: String) {
        presentAlertOnTheMainThread(title: "Success", Message: msg)
    }
    
    private func configureGeneralFailureCase(msg: String) {
        presentAlertOnTheMainThread(title: "Failure", Message: msg)
    }
}
