//
//  DecksVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit

class DecksVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavigationBar()
    }
    

    private func configureNavigationBar() {
        title = "Decks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
