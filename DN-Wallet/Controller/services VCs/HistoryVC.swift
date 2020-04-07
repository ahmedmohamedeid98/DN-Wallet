//
//  HistoryVC.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/13/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {

    
    @IBOutlet weak var consumptionsAmount: UILabel!
    @IBOutlet weak var receivedAmount: UILabel!
    @IBOutlet weak var donationsAmount: UILabel!
    var hh: [HistoryCategory] = [HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25/7/23 8:06", category: 0, innerCategory: 0),
    HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25/7/23 8:06", category: 0, innerCategory: 0),
    HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25/7/23 8:06", category: 1, innerCategory: 1),
    HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "XCN", date: "25/7/23 8:06", category: 0, innerCategory: 1),
    HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "USD", date: "25/7/23 8:06", category: 1, innerCategory: 1),
    HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25/7/23 8:06", category: 2, innerCategory: 0),
    HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25/7/23 8:06", category: 2, innerCategory: 0),
    HistoryCategory(id: "s4d5", email: "ahmed@gmail.com", amount: 25, currency: "EGP", date: "25/7/23 8:06", category: 2, innerCategory: 0)]
    var HData : History!
    var consumData = [HistoryCategory]()
    var reciveData = [HistoryCategory]()
    var donationData = [HistoryCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        HData = History(consumption: 250, recive: 350, donation: 400, result: hh)
        self.consumptionsAmount.text = "\(HData.consumption) $"
        self.receivedAmount.text =  "\(HData.recive) $"
        self.donationsAmount.text = "\(HData.donation) $"
        parseData(HData.result)
    }
    
    deinit {
        print("HistoryVC deallocated")
    }
    
    // convert the status bar color from black to white
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
            vc.configureController(title: "Consumption" , segItems: HDetails.consumption.segItems() ,data: consumData, infoLabel: HDetails.consumption.infoLabel())
            self.present(vc, animated: true, completion: nil)
        }else if sender.tag == 1 {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: HDetails.received.title(), segItems: HDetails.received.segItems(),data: reciveData , infoLabel: HDetails.received.infoLabel())
            self.present(vc, animated: true, completion: nil)
        }else {
            let vc = HistoryDetailsVC()
            vc.modalPresentationStyle = .fullScreen
            vc.configureController(title: HDetails.donations.title(), segItems: HDetails.donations.segItems(), data: donationData, infoLabel: HDetails.donations.infoLabel(), withSeg: false)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
