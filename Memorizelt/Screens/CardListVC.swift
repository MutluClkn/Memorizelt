//
//  CardListVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit
import SnapKit

//MARK: - CARD LIST VC
final class CardListVC: UIViewController {
    
    private let addCardButton = MZFloatingButton(bgColor: UIColor(hex: "#333B4C"),
                                                 cornerRadius: 35,
                                                 systemImage: "plus")
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let coreDataManager = CoreDataManager.shared
    private var flashcards: [Flashcard] = []
    
    
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
    
    
    private func configureNavigationBar() {
        title = "Cards"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func loadFlashcards() {
        flashcards = coreDataManager.fetchFlashcards()
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
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
}


//MARK: - TABLE VIEW CONFIGURATIONS
extension CardListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.cardListCell, for: indexPath) as? CardListCell else { return UITableViewCell() }
        let flashcard = flashcards[indexPath.row]
        cell.titleLabel.text = flashcard.category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let vc = CardVC()
            vc.titleLabel.text = self.flashcards[indexPath.row].category
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}
