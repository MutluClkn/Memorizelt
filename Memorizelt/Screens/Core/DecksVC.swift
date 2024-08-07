//
//  DecksVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit
import CoreData
import SnapKit

//MARK: - DecskVC
final class DecksVC: UIViewController {
    
    //Variables
    private let titleLabel = MZLabel(text: Texts.DeckScreen.title, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 30, textColor: Colors.text)
    private let scrollView = MZScrollView()
    private let contentView = UIView()
    private let separatorLine = MZContainerView(cornerRadius: 0, bgColor: Colors.secondary)
    private let tableView = MZTableView(isScrollEnabled: false)
    private let coreDataManager = CoreDataManager.shared
    private var flashcardsByCategory: [String: [Flashcard]] = [:]
    private var categories: [String] = []
    
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        configureNavigationBar()
        configureTableView()
        loadFlashcards()
        setupConstraints()
    }
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = Colors.background
        tableView.backgroundColor = Colors.background
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFlashcards()
    }
    
    
    //NavigationBar & TabBar
    private func configureNavigationBar() {
        self.title = Texts.TabBar.deckTitle
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.mainTextColor]
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        cell.quantity.text = "(\(category.count))"
        
        cell.tintColor = Colors.accent
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        
        DispatchQueue.main.async {
            let editDeckVC = EditDeckVC()
            editDeckVC.modalPresentationStyle = .fullScreen
            editDeckVC.flashcards = flashcards
            editDeckVC.category = category
            self.present(editDeckVC, animated: true)
        }
    }
}

extension DecksVC {
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorLine)
        contentView.addSubview(tableView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.equalTo(scrollView)
            make.right.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(25)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(5)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.height.equalTo(categories.count * 50)
        }
    }
    
}
