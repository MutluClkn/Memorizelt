//
//  TabBarVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        controllersConfiguration()
    }
    
    private func controllersConfiguration() {
        
        let cardListVC = UINavigationController(rootViewController: HomeVC())
        cardListVC.tabBarItem.image = UIImage(systemName: Texts.TabBar.houseIcon)
        cardListVC.title = Texts.TabBar.homeTitle
        cardListVC.navigationBar.tintColor = Colors.accent
        
        
        let decksVC = UINavigationController(rootViewController: DecksVC())
        decksVC.tabBarItem.image = UIImage(systemName: Texts.TabBar.lanyardcardIcon)
        decksVC.title = Texts.TabBar.deckTitle
        decksVC.navigationBar.tintColor = Colors.accent
        
        
        setViewControllers([cardListVC, decksVC], animated: true)
        
    }

}
