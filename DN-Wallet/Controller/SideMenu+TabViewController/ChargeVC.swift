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
        view.backgroundColor = .DnBackgroundColor
        dropDown.delegate = self
        amountField.delegate = self
        creditTable.delegate = self
        setupCreditTableDataSource()
        creditTable.dataSource = tableDataSource
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
            cell.currentIndexPath = indexPath
            cell.cellDelegate = self
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
    func selectedItem(title: String) {
        dropDown.text = title
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dropDown {
            textField.endEditing(true)
            amountField.endEditing(true)
            let vc = PopUpMenu()
            vc.menuDelegate = self
            vc.originalDataSource = [PopMenuItem(image: nil, title: "Egyption Pound")]
            self.present(vc, animated: true, completion: nil)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension ChargeVC: UITableViewDelegate , SelectedCardDelegate{
    
    func freeLastSelectedIndexPath() {
        lastSelectedIndexPath = nil
    }
    
    func selectedCreditCard(id: String, currentIndex: IndexPath) {
        self.selectedCardId = id
        print("selected Id: \(id)")
        toggleLastIndexPath(currentIndex)
    }
    // check if there is cell selected befor, if it is then deselect it.
    private func toggleLastIndexPath(_ currentIndex: IndexPath) {
        guard let currentCell = creditTable.cellForRow(at: currentIndex) as? ChargeCreditCell else {return}
        if lastSelectedIndexPath != nil {
            if lastSelectedIndexPath == currentIndex {
                currentCell.checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
                currentCell.toggle = true
            } else {
                guard let lastCell = creditTable.cellForRow(at: lastSelectedIndexPath!) as? ChargeCreditCell else {return}
                lastCell.checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
                lastCell.toggle = true
                
                currentCell.checkBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                currentCell.toggle = false
                lastSelectedIndexPath = currentIndex
            }
        } else {
            lastSelectedIndexPath = currentIndex
            currentCell.checkBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            currentCell.toggle = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleLastIndexPath(indexPath)
        guard let cell = tableView.cellForRow(at: indexPath) as? ChargeCreditCell else {return}
        self.selectedCardId = cell.credit_Id
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
