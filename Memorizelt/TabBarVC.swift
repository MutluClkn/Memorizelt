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
        view.backgroundColor = .systemBackground
        controllersConfiguration()
    }
    
    private func controllersConfiguration() {
        let cardListVC = UINavigationController(rootViewController: CardListVC())
        cardListVC.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle")
        
        
        let decksVC = UINavigationController(rootViewController: DecksVC())
        decksVC.tabBarItem.image = UIImage(systemName: "lanyardcard")
        
        setViewControllers([cardListVC, decksVC], animated: true)
        
    }

}
