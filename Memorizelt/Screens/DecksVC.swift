//
//  DecksVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit
import CoreData

//MARK: - DecskVC
final class DecksVC: UIViewController {
    
    //Variables
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let coreDataManager = CoreDataManager.shared
    private var flashcardsByCategory: [String: [Flashcard]] = [:]
    private var categories: [String] = []

    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureNavigationBar()
        configureTableView()
        loadFlashcards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

    //NavigationBar
    private func configureNavigationBar() {
        title = "Decks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DeckListCell.self, forCellReuseIdentifier: Cell.deckListCell)
        view.addSubview(tableView)
    }
    
    //CoreDataManager
    //Load Flashcards
    private func loadFlashcards() {
        flashcardsByCategory = coreDataManager.fetchFlashcardsGroupedByCategory()
        
        // Sort categories by the earliest creation date within each category
        categories = flashcardsByCategory.keys.sorted { category1, category2 in
            let date1 = flashcardsByCategory[category1]?.first?.creationDate ?? Date.distantPast
            let date2 = flashcardsByCategory[category2]?.first?.creationDate ?? Date.distantPast
            return date1 > date2
        }
        
        tableView.reloadData()
    }

}


extension DecksVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.deckListCell, for: indexPath) as? DeckListCell else { return UITableViewCell() }
        
        let category = categories[indexPath.row]
        cell.titleLabel.text = category
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}
