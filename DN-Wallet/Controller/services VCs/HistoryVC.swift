//
//  HistoryVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/13/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

final class HistoryVC: UIViewController {

    
    @IBOutlet weak var consumptionsAmount: UILabel!
    @IBOutlet weak var receivedAmount: UILabel!
    @IBOutlet weak var donationsAmount: UILabel!
    var hh: [HistoryCategory] =
    [
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 0, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 0, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 1, innerCategory: 1),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "XCN", date: "25-7-23 8:06", category: 0, innerCategory: 1),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "USD", date: "25-7-23 8:06", category: 1, innerCategory: 1),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 2, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 2, innerCategory: 0),
    HistoryCategory(email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25-7-23 8:06", category: 2, innerCategory: 0)
    ]
    var HData : History!
    var consumData = [HistoryCategory]()
    var reciveData = [HistoryCategory]()
    var donationData = [HistoryCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .DnVcBackgroundColor
        setupNavigationBar()
        HData = History(consumption: 250, receive: 350, donation: 400, result: hh)
        self.consumptionsAmount.text = "\(HData.consumption) $"
        self.receivedAmount.text =  "\(HData.receive) $"
        self.donationsAmount.text = "\(HData.donation) $"
        parseData(HData.result)
    }
    
    deinit {
        print("HistoryVC deallocated")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    fileprivate func setupNavigationBar() {
        self.configureNavigationBar(title: K.vc.historyTitle)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: K.sysImage.leftArrow), style: .plain, target: self, action: #selector(backBtnWasPressed))
    }
    
    func parseData(_ HistoryData: [HistoryCategory]) {
        for item in HistoryData {
            if item.category == 0 {
                self.consumData.append(item)
            }else if item.category == 1 {
                self.reciveData.append(item)
            }else{
                self.donationData.append(item)
            }
        }
    }
    /// IBAction method called when any category is beign selected
    /// - Parameter sender: use to access button properity like tag.
    @IBAction func detailsBtnWasPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: K.vc.consumptionTitle , segItems: HDetails.consumption.segItems() ,data: consumData, infoLabel: HDetails.consumption.infoLabel())
            navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag == 1 {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: K.vc.receivedTitle , segItems: HDetails.received.segItems(),data: reciveData , infoLabel: HDetails.received.infoLabel())
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: K.vc.donationTitle , segItems: HDetails.donations.segItems(), data: donationData, infoLabel: HDetails.donations.infoLabel(), withSeg: false)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func backBtnWasPressed() {
        dismiss(animated: true, completion: nil)
    }

}
