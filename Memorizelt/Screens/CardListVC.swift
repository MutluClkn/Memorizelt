//
//  CardListVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit
import SnapKit
import CoreData

//MARK: - CARD LIST VC
final class CardListVC: UIViewController, AddNewDeckDelegate {
    
    
    //Variables
    private let addCardButton = MZFloatingButton(bgColor: UIColor(hex: "#333B4C"),
                                                 cornerRadius: 35,
                                                 systemImage: "plus")
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
        configureTableView()
        configureNavigationBar()
        configureAddCardButton()
        
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
        title = "Cards"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.tintColor = .white
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
    
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardListCell.self, forCellReuseIdentifier: Cell.cardListCell)
        view.addSubview(tableView)
    }
    
    private func configureAddCardButton() {
        view.addSubview(addCardButton)
        
        addCardButton.addTarget(self, action: #selector(pushAddCardVC), for: .touchUpInside)
        
        addCardButton.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    @objc func pushAddCardVC() {
        DispatchQueue.main.async {
            let vc = AddNewDeckVC()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    func didAddNewDeck() {
        loadFlashcards()
    }
    
}


//MARK: - TABLE VIEW CONFIGURATIONS
extension CardListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.cardListCell, for: indexPath) as? CardListCell else { return UITableViewCell() }
        let category = categories[indexPath.row]
        cell.titleLabel.text = category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        guard let flashcards = flashcardsByCategory[category] else { return }
        
        DispatchQueue.main.async {
            let vc = CardVC()
            vc.titleLabel.text = category
            vc.flashcards = flashcards
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
