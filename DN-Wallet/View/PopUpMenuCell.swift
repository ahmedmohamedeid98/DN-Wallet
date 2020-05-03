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
    
    func getTitle() -> String {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(leadingImage)
        addSubview(title)
        leadingImage.DNLayoutConstraint(left: leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 30, height: 30), centerV: true)
        title.DNLayoutConstraint(left: leadingImage.rightAnchor, right: rightAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), centerV: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
