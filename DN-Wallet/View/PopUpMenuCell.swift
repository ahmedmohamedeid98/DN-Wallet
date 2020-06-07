//
//  PopUpMenuCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 5/2/20.
//  Copyright © 2020 DN. All rights reserved.
//

class PopUpMenuCell: UITableViewCell {
    
    static let reuseIdentifier = "pop-up-cell-identifier"
    
    var data: PopMenuItem? {
        didSet {
            guard let data = data else {return}
            leadingImage.image = data.image
            title.text = data.title
        }
    }
    
    var getTitle: String {
        return title.text ?? "Something Wrong"
    }
    
    private let leadingImage: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    private let title: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        return lb
    }()
    /*
    private let checkBoxImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .DnColor
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return imageView
    }()
    */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupLayout()
    }
    /*
    func checkBoxToggle(check: Bool = true) {
        if check {
            checkBoxImage.image = UIImage(systemName: "checkmark.fill.circle")
        } else {
            checkBoxImage.image = UIImage(systemName: "circle")
        }
    }
    */
    private func setupLayout() {
        addSubview(leadingImage)
        addSubview(title)
        //addSubview(checkBoxImage)
        leadingImage.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 30, height: 30), centerV: true)
        title.DNLayoutConstraint(left: leadingImage.rightAnchor, right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), centerV: true)
        /*
        checkBoxImage.DNLayoutConstraint(left: nil, right: rightAnchor, bottom: nil, margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: .zero, centerH: false, centerV: true)
         */
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
