//
//  DNSegmentControl.swift
//  DN-Wallet
//
//  Created by Mac OS on 7/20/20.
//  Copyright © 2020 DN. All rights reserved.
//

protocol DNSegmentControlDelegate: class {
    func segmentValueChanged(to index: Int)
}

class DNSegmentControl: UIView {
    
    weak var delegate: DNSegmentControlDelegate?
    private let segmentControl: UISegmentedControl = UISegmentedControl()
    var firstSegmentTitle: String? = nil {
        didSet {
            guard let title = firstSegmentTitle else { return }
            segmentControl.setTitle(title, forSegmentAt: 0)
        }
    }
    var secondSegmentTitle: String? {
        didSet {
            guard let title = secondSegmentTitle else { return }
            segmentControl.setTitle(title, forSegmentAt: 1)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    
    private func configure() {
        backgroundColor = .clear
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.insertSegment(with: nil, at: 0, animated: true)
        segmentControl.insertSegment(with: nil, at: 1, animated: true)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor          = UIColor.black
        segmentControl.layer.borderColor        = UIColor.white.cgColor
        segmentControl.selectedSegmentTintColor = UIColor.white
        segmentControl.layer.borderWidth        = 1
        
        let titleTextAttributes     = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        let titleTextAttributes1    = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        
        segmentControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        
        addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func segmentAction(_ sender: UISegmentedControl) {
        if let delegate = delegate {
            delegate.segmentValueChanged(to: sender.selectedSegmentIndex)
        }
    }
    
    func enableSegmentAt(index: Int) {
        segmentControl.setEnabled(true, forSegmentAt: index)
    }
    
    
    func disableSegmentAt(index: Int) {
        segmentControl.setEnabled(false, forSegmentAt: index)
    }
    
    func selectSegmentAt(index: Int) {
        segmentControl.selectedSegmentIndex = index
    }
    
}
