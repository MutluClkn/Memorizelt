//
//  TabBarVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit

final class TabBarVC: UITabBarController {
    
    private let customTabBar = CustomTabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(customTabBar, forKey: "tabBar")
        
        controllersConfiguration()
    }
    
    private func controllersConfiguration() {
        
        let cardListVC = UINavigationController(rootViewController: HomeVC())
        cardListVC.tabBarItem.image = UIImage(systemName: Texts.TabBar.houseIcon)
        cardListVC.tabBarItem.title = Texts.TabBar.homeTitle
        
        
        let decksVC = UINavigationController(rootViewController: DecksVC())
        decksVC.tabBarItem.image = UIImage(systemName: Texts.TabBar.lanyardcardIcon)
        decksVC.tabBarItem.title = Texts.TabBar.deckTitle
        
        
        setViewControllers([cardListVC, decksVC], animated: true)
        
    }

}
