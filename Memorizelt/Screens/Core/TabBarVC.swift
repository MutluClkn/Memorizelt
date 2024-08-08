//
//  TabBarVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit
import SnapKit

final class TabBarVC: UIViewController {
    
    private let tabBarView = UIView()
    private let tabBarStackView = MZStackView(axis: .horizontal, distribution: .fillEqually, spacing: 1.5)
    
    private let homeView = UIView()
    private let addView = UIView()
    private let deckView = UIView()
    
    private let homeSelectView = UIView()
    private let addSelectView = UIView()
    private let deckSelectView = UIView()
    
    private let homeImage = UIImageView()
    private let addImage = UIImageView()
    private let deckImage = UIImageView()
    
    private let homeButton = UIButton()
    private let addButton = UIButton()
    private let deckButton = UIButton()
    
    private let containerView = UIView()
    
    private let homeVC = HomeVC()
    private let addNewCardVC = AddNewCardVC()
    private let deckVC = DecksVC()
    
    private let primaryColor = Colors.primary
    private let clearColor = UIColor.clear
    private let bgColor = Colors.background
    
    private let cornerRadius: CGFloat = 28
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        
        homeButtonDidTap()
        
        configure()
        configureViews()
        configureImages()
        configureButtons()
        
    }
    
    
    private func configureViews() {
        tabBarView.backgroundColor = primaryColor
        tabBarView.layer.cornerRadius = cornerRadius
        
        homeView.backgroundColor = clearColor
        homeView.layer.cornerRadius = cornerRadius
        
        addView.backgroundColor = clearColor
        addView.layer.cornerRadius = cornerRadius
        
        deckView.backgroundColor = clearColor
        deckView.layer.cornerRadius = cornerRadius
        
        homeSelectView.backgroundColor = bgColor
        homeSelectView.layer.cornerRadius = 1.5
        
        addSelectView.backgroundColor = bgColor
        addSelectView.layer.cornerRadius = 1.5
        
        deckSelectView.backgroundColor = bgColor
        deckSelectView.layer.cornerRadius = 1.5
    }
    
    private func configureImages() {
        homeImage.image = UIImage(systemName: Texts.TabBar.houseIcon)
        homeImage.tintColor = bgColor
        
        addImage.image = UIImage(systemName: Texts.HomeScreen.plusIcon)
        addImage.tintColor = bgColor
        
        deckImage.image = UIImage(systemName: Texts.TabBar.lanyardcardIcon)
        deckImage.tintColor = bgColor
    }
    
    private func configureButtons() {
        homeButton.setTitle("", for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonDidTap), for: .touchUpInside)
        
        addButton.setTitle("", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        
        deckButton.setTitle("", for: .normal)
        deckButton.addTarget(self, action: #selector(deckButtonDidTap), for: .touchUpInside)
    }
    
    private func hiddenUnselectedView(home: Bool, add: Bool, deck: Bool) {
        homeSelectView.isHidden = !home
        addSelectView.isHidden = !add
        deckSelectView.isHidden = !deck
    }
    
    @objc func homeButtonDidTap() {
        hiddenUnselectedView(home: true, add: false, deck: false)
        showViewController(homeVC)
    }
    
    @objc func addButtonDidTap() {
        hiddenUnselectedView(home: false, add: true, deck: false)
        showViewController(addNewCardVC)
    }
    
    @objc func deckButtonDidTap() {
        hiddenUnselectedView(home: false, add: false, deck: true)
        showViewController(deckVC)
    }
    
    private func showViewController(_ viewController: UIViewController) {
        // Remove the current child view controller if any
        for childVC in children {
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
        
        // Add the new child view controller
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func configure() {
        view.addSubview(containerView)
        view.addSubview(tabBarView)
        tabBarView.addSubview(tabBarStackView)
        
        tabBarStackView.addArrangedSubview(homeView)
        tabBarStackView.addArrangedSubview(addView)
        tabBarStackView.addArrangedSubview(deckView)
        
        homeView.addSubview(homeImage)
        addView.addSubview(addImage)
        deckView.addSubview(deckImage)
        
        homeView.addSubview(homeSelectView)
        addView.addSubview(addSelectView)
        deckView.addSubview(deckSelectView)
        
        homeView.addSubview(homeButton)
        addView.addSubview(addButton)
        deckView.addSubview(deckButton)
        
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(tabBarView.snp.top)
        }
        
        tabBarView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(56)
        }
        
        tabBarStackView.snp.makeConstraints { make in
            make.top.equalTo(tabBarView.snp.top)
            make.bottom.equalTo(tabBarView.snp.bottom)
            make.left.equalTo(tabBarView.snp.left)
            make.right.equalTo(tabBarView.snp.right)
        }
        
        homeImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(tabBarView.snp.height).multipliedBy(0.43)
        }
        
        addImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(tabBarView.snp.height).multipliedBy(0.43)
        }
        
        deckImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(tabBarView.snp.height).multipliedBy(0.43)
        }
        
        homeSelectView.snp.makeConstraints { make in
            make.top.equalTo(homeImage.snp.bottom).offset(7)
            make.centerX.equalTo(homeImage.snp.centerX)
            make.width.equalTo(homeImage.snp.width).multipliedBy(0.8)
            make.height.equalTo(1.5)
        }
        
        addSelectView.snp.makeConstraints { make in
            make.top.equalTo(addImage.snp.bottom).offset(7)
            make.centerX.equalTo(addImage.snp.centerX)
            make.width.equalTo(addImage.snp.width).multipliedBy(0.8)
            make.height.equalTo(1.5)
        }
        
        deckSelectView.snp.makeConstraints { make in
            make.top.equalTo(deckImage.snp.bottom).offset(7)
            make.centerX.equalTo(deckImage.snp.centerX)
            make.width.equalTo(deckImage.snp.width).multipliedBy(0.8)
            make.height.equalTo(1.5)
        }
        
        homeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deckButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
