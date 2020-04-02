//
//  ContainerViewController.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    
    let contentView:  UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    let skipBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("skip", for: .normal)
        btn.tintColor = UIColor.DN.DarkBlue.color()
        btn.titleLabel?.font = UIFont.DN.Regular.font(size: 20)
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(skipButtonWasPressed), for: .touchUpInside)
        return btn
    }()
    let nextBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("next", for: .normal)
        btn.tintColor = UIColor.DN.DarkBlue.color()
        btn.titleLabel?.font = UIFont.DN.Regular.font(size: 20)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(nextButtonWasPressed), for: .touchUpInside)
        return btn
    }()
    
    let dataSource = ["first", "second", "third"]
    var currentViewControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurePageControllerView()
        setupView()
    }
    
    func configurePageControllerView() {
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageViewController.view)
        
        let views : [String : UIView] = ["pageView" : pageViewController.view]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                 options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        //pageViewController.view.DNLayoutConstraint(contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, margins: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
        guard let startViewController = detailViewControllerAt(index: currentViewControllerIndex) else { return }
        pageViewController.setViewControllers([startViewController], direction: .forward, animated: true)

    }
    
    func detailViewControllerAt(index: Int) -> DataViewController? {
        print("detail index : \(index)")
        if index >= dataSource.count || dataSource.count == 0 {
            return nil
        }
        
        let dataViewController = DataViewController()
        dataViewController.index = index
        dataViewController.text = dataSource[index]
        
        return dataViewController
    }
    
    func setupView() {
        let Hstack = UIStackView(arrangedSubviews: [skipBtn,UIView(), nextBtn])
        let Vstack = UIStackView(arrangedSubviews: [contentView, Hstack])
        Hstack.axis = .horizontal
        Hstack.distribution = .fillEqually
        Hstack.alignment = .fill
        Hstack.spacing = 8
        Hstack.backgroundColor = .red
        
        Vstack.axis = .vertical
        Vstack.distribution = .fill
        Vstack.alignment = .fill
        Vstack.spacing = 8
        Vstack.backgroundColor = .yellow
        
        view.addSubview(Vstack)
        Hstack.DNLayoutConstraint(size: CGSize(width: 0, height: 50))
        Vstack.DNLayoutConstraintFill(top: 20 , left: 20 , right: 20, bottom: 20)
    }
    
    @objc func skipButtonWasPressed() {
        print("skip")
    }
    
    @objc func nextButtonWasPressed() {
        print("next")
    }
    

}

extension ContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let datavc = viewController as? DataViewController
        guard var currentIndex = datavc?.index else { return nil }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let datavc = viewController as? DataViewController
        guard var currentIndex = datavc?.index else { return nil }
    
        if currentIndex == dataSource.count {
            return nil
        }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    
}
