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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFlashcards()
    }
    
    
    //NavigationBar & TabBar
    private func configureNavigationBar() {
        title = "Decks"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.tintColor = .white
    }
    
    
    //Configure TableView
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DeckListCell.self, forCellReuseIdentifier: Cell.deckListCell)
        view.addSubview(tableView)
    }
    
    
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

//MARK: - TableView Delegate/DataSource
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = categories[indexPath.row]
            
            if let flashcards = flashcardsByCategory[category] {
                for flashcard in flashcards {
                    coreDataManager.deleteFlashcard(flashcard: flashcard)
                }
            }
            
            flashcardsByCategory.removeValue(forKey: category)
            categories.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let flashcards = flashcardsByCategory[category] ?? []
        
        let editDeckVC = EditDeckVC()
        
        editDeckVC.flashcards = flashcards
        editDeckVC.category = category
        
        navigationController?.pushViewController(editDeckVC, animated: true)
        
    }
    
}
