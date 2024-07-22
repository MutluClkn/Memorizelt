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
        view.backgroundColor = .black
        controllersConfiguration()
    }
    
    private func controllersConfiguration() {
        let addNewDeck = UINavigationController(rootViewController: AddNewDeckVC())
        addNewDeck.tabBarItem.image = UIImage(systemName: "plus.rectangle.portrait")
        addNewDeck.title = "Add"
        
        
        let cardListVC = UINavigationController(rootViewController: CardListVC())
        cardListVC.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle")
        cardListVC.title = "Cards"
        
        
        let decksVC = UINavigationController(rootViewController: DecksVC())
        decksVC.tabBarItem.image = UIImage(systemName: "lanyardcard")
        decksVC.title = "Decks"
        
        
        setViewControllers([addNewDeck, cardListVC, decksVC], animated: true)
        
    }

}
