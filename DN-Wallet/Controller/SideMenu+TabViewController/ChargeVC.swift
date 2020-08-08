//
//  ChargeVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class ChargeVC: UIViewController {
    
    
    //MARK:- Outlets
    @IBOutlet weak var dropDown: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var segmentControl: DNSegmentControl!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var creditTable: UITableView!
    
    //MARK:- Properities
    var lastSelectedIndexPath: IndexPath?
    var selectedCardId: String?
    var tableDataSource: UITableViewDiffableDataSource<Section, GetPaymentCards>!
    var cards: [GetPaymentCards]  = []
    var selectedSegmentIndex: Int = 0
    var selectedCurrencyCode: String = "EGP"
    
    //MARK:- Initialization
    fileprivate func configureSegmentControl() {
        segmentControl.firstSegmentTitle    = "Charge"
        segmentControl.secondSegmentTitle   = "Withdrew"
        segmentControl.delegate             = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNavigationBar()
        configureSegmentControl()
        
        dropDown.delegate       = self
        dropDown.doNotShowTheKeyboard()
        amountField.delegate    = self
        creditTable.delegate    = self
        setupCreditTableDataSource()
        initViewControllerWithData()
        
    }
    
    private func setUserPreference() {
        if let currency = UserPreference.getStringValue(withKey: UserPreference.currencyKey) {
            dropDown.text = currency
        }
    }
    
    func handleNavigationBar() {
        navigationItem.title                                        = "Charge - Withdraw"
        let appearance                                              = UINavigationBarAppearance()
        appearance.titleTextAttributes                              = [.foregroundColor: UIColor.white]
        appearance.backgroundColor                                  = .DnColor
        navigationController?.navigationBar.standardAppearance      = appearance
        navigationController?.navigationBar.compactAppearance       = appearance
        navigationController?.navigationBar.scrollEdgeAppearance    = appearance
        let scanBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnPressed))
        navigationItem.rightBarButtonItem                           = scanBarButton
        navigationItem.rightBarButtonItem?.tintColor                = .white
        
    }
    
    private func setupCreditTableDataSource() {
        tableDataSource = UITableViewDiffableDataSource<Section, GetPaymentCards>(tableView: creditTable, cellProvider: { (MyTable, indexPath, data) -> UITableViewCell? in
            guard let cell = MyTable.dequeueReusableCell(withIdentifier: ChargeCreditCell.reuseIdentifier, for: indexPath)  as? ChargeCreditCell else {return UITableViewCell()}
            cell.data = data
            return cell
        })
        updateTableViewWithData()
    }
    
    private func updateTableViewWithData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GetPaymentCards>()
        snapshot.appendSections(Section.allCases)
        for item in cards {
            snapshot.appendItems([item])
        }
        tableDataSource.apply(snapshot)
    }
    
    //MARK:- Actions
    @objc func doneBtnPressed() {
        
        guard let amount = amountField.text else {
            self.presentDNAlertOnTheMainThread(title: "Failure", Message: "amount is required. and must be large than 0.0")
            return
        }
        guard let cardID =  selectedCardId else {
            self.presentDNAlertOnTheMainThread(title: "Failure", Message: "You must select an payment card.")
            return
        }
        
        Hud.showLoadingHud(onView: view, withLabel: "In Process....")
        // charge
        if selectedSegmentIndex == 0 {
            TransferManager.shared.chargeAccount(withData: Transfer(amount: amount, currency_code: selectedCurrencyCode), id: cardID) { result in
                Hud.hide(after: 0)
                switch result {
                    case .success(let res):
                        self.handelChargeSuccessCase(msg: res.success)
                    case .failure(let err):
                        self.handelChargeFailureCase(msg: err.localizedDescription)
                }
            }
        }
        // withdraw
        else {
            TransferManager.shared.withdrawAccount(withData: Transfer(amount: amount, currency_code: selectedCurrencyCode), id: cardID) { result in
                Hud.hide(after: 0)
                switch result {
                    case .success(let res):
                        self.handelWithdrawSuccessCase(msg: res.success)
                    case .failure(let err):
                        self.handelWithdrewFailureCase(msg: err.localizedDescription)
                }
            }
        }
    }
    
    private func handelChargeSuccessCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Success", Message: msg + ", your request may take from 10 - 30 seconds to confirmed.")
        NotificationCenter.default.post(name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
    }
    
    private func handelWithdrawSuccessCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Success", Message: msg + ", your request may take from 10 - 30 seconds to confirmed.")
        NotificationCenter.default.post(name: NSNotification.Name("BALANCEWASUPDATED"), object: nil)
    }
    
    private func handelChargeFailureCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Failure", Message: msg)
    }
    
    private func handelWithdrewFailureCase(msg: String) {
        self.presentDNAlertOnTheMainThread(title: "Failure", Message: msg)
    }
    

}

extension ChargeVC: UITextFieldDelegate, PopUpMenuDelegate {
    func selectedItem(title: String, code: String?) {
        dropDown.text = title + "  [\(code ?? " ")]"
        selectedCurrencyCode = code ?? "EGP"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dropDown {
            textField.endEditing(true)
            amountField.endEditing(true)
            self.presentPopUpMenu(withCategory: .currency, to: self)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension ChargeVC: UITableViewDelegate {
    
    func unCheckLastCell() {
        if let cell = creditTable.cellForRow(at: lastSelectedIndexPath!) as? ChargeCreditCell {
            cell.checkBoxToggle(check: false)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChargeCreditCell {
            if lastSelectedIndexPath != nil {
                unCheckLastCell()
            }
            cell.checkBoxToggle(check: true)
            lastSelectedIndexPath = indexPath
            self.selectedCardId = cell.credit_Id
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = "  Select Payment Card"
        header.textColor = .DnTextColor
        
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
}

// handel segmentControl Action
extension ChargeVC: DNSegmentControlDelegate {
    func segmentValueChanged(to index: Int) {
        if index == 0 {
            // charge...
            selectedSegmentIndex = 0
        } else {
            // withdrew...
            selectedSegmentIndex = 1
        }
    }
    
    
}

//Networking
extension ChargeVC {
    func initViewControllerWithData() {
        TransferManager.shared.getPaymentCards { (result) in
            switch result {
                case .success(let data):
                    self.handelGetPaymentCardsSuccessCase(cards: data)
                case .failure(let err):
                    self.handelGetPaymentCardsFailureCase(withError: err.localizedDescription)
            }
        }
    }
    
    func handelGetPaymentCardsSuccessCase(cards: [GetPaymentCards]) {
        self.cards = cards
        DispatchQueue.main.async { self.updateTableViewWithData() }
    }
    
    func handelGetPaymentCardsFailureCase(withError err: String) {
        print("Failure Get Cards: \(err)")
    }
    
}
