//
//  CardListVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit

class CardListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardListCell.self, forCellReuseIdentifier: Constant.cardListCell)
        view.addSubview(tableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cardListCell, for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.titleLabel.text = "Card \(indexPath.row + 1)"
        return cell
    }

}
