//
//  DataViewController.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    let imageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .yellow
        return img
    }()
    
    var text: String?
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "lllllhhhhjjjj"
        lb.textAlignment = .center
        lb.font = UIFont.DN.Regular.font(size: 25)
        lb.textColor = UIColor.DN.DarkBlue.color()
        return lb
    }()
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        label.text = text
        setupView()
       
    }
    
    func setupView() {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.DNLayoutConstraintFill()
    }

}
