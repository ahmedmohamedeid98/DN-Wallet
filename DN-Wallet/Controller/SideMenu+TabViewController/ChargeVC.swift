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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var creditTable: UITableView!
    
    //MARK:- Properities
    var lastSelectedIndexPath: IndexPath?
    var selectedCardId: String = "0"
    var tableDataSource: UITableViewDiffableDataSource<Section, CardInfo>!
    var cards: [CardInfo] = [CardInfo(id: "1", name: "Visa", type: "prepad", digits: "1547"),
    CardInfo(id: "2", name: "Master Card", type: "prepad", digits: "5427"),
    CardInfo(id: "3", name: "Meza", type: "charge", digits: "8437")]
    
    //MARK:- Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNavigationBar()
        view.backgroundColor = .DnVcBackgroundColor
        dropDown.delegate = self
        amountField.delegate = self
        creditTable.delegate = self
        setupCreditTableDataSource()
        creditTable.dataSource = tableDataSource
        
        dropDown.text = "EGP"
        //setUserPreference()
    }
    
    private func setUserPreference() {
        if let currency = UserPreference.getStringValue(withKey: UserPreference.currencyKey) {
            dropDown.text = currency
        }
    }
    
    func handleNavigationBar() {
        navigationItem.title = "Charge - Withdraw"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .DnDarkBlue
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let scanBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnPressed))
        navigationItem.rightBarButtonItem = scanBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
            
        }
    
    private func setupCreditTableDataSource() {
        tableDataSource = UITableViewDiffableDataSource(tableView: creditTable, cellProvider: { (MyTable, indexPath, data) -> UITableViewCell? in
            guard let cell = MyTable.dequeueReusableCell(withIdentifier: ChargeCreditCell.reuseIdentifier, for: indexPath)  as? ChargeCreditCell else {return UITableViewCell()}
            cell.data = data
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CardInfo>()
        snapshot.appendSections(Section.allCases)
        for item in cards {
            snapshot.appendItems([item])
        }
        tableDataSource.apply(snapshot)
    }
    
    
    //MARK:- Actions
    @objc func doneBtnPressed() {
        print("done button pressed")
    }
    

}

extension ChargeVC: UITextFieldDelegate, PopUpMenuDelegate {
    func selectedItem(title: String, code: String?) {
        dropDown.text = title + "\t\t(\(code ?? " "))"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dropDown {
            textField.endEditing(true)
            amountField.endEditing(true)
            let vc = PopUpMenu()
            vc.menuDelegate = self
            vc.dataSource = .currency
            self.present(vc, animated: true, completion: nil)
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
        header.textColor = .label
        return header
    }
    
    
}
