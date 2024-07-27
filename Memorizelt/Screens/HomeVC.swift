//
//  HomeVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit
import SnapKit
import CoreData

//MARK: - HomeVC
final class HomeVC: UIViewController, AddNewDeckDelegate {

    //UI Elements
    private let scrollView = MZScrollView()
    private let contentView = UIView()
    private let containerStack = MZStackView(axis: .horizontal, distribution: .fillEqually, spacing: 10)
    private let leftDashboardContainer = MZContainerView(cornerRadius: 15, bgColor: UIColor(hex: "#CDA164"))
    private let rightDashboardContainer = MZContainerView(cornerRadius: 15, bgColor: UIColor(hex: "#9BA2EF"))
    private let pendingCardQuantityLabel = MZLabel(text: "2", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interSemiBold, fontSize: 30, textColor: .black)
    private let pendingCardLabel = MZLabel(text: "Pending Cards", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .black)
    private let tableViewTitleLabel = MZLabel(text: "Pending Cards", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 17, textColor: .white)
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    private let addCardButton = MZFloatingButton(bgColor: UIColor(hex: "#333B4C"), cornerRadius: 35, systemImage: "plus")

    //Variables
    private let coreDataManager = CoreDataManager.shared
    private var flashcardsByCategory: [String: [Flashcard]] = [:]
    private var categories: [String] = []

    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        loadFlashcards()
        configureTableView()
        configureTabBar()
        configureAddCardButton()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFlashcards()
    }

    //TabBar
    private func configureTabBar() {
        self.navigationItem.title = "Dashboard"
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
    }

    private func configureAddCardButton() {
        
        addCardButton.addTarget(self, action: #selector(pushAddCardVC), for: .touchUpInside)

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
extension HomeVC: UITableViewDataSource, UITableViewDelegate {

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

//MARK: - Constraints Setup
extension HomeVC {
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(addCardButton)
        contentView.addSubview(tableViewTitleLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(containerStack)
        containerStack.addArrangedSubview(leftDashboardContainer)
        containerStack.addArrangedSubview(rightDashboardContainer)
        leftDashboardContainer.addSubview(pendingCardQuantityLabel)
        leftDashboardContainer.addSubview(pendingCardLabel)
        
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
        
        addCardButton.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        containerStack.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(view.frame.size.height * 0.15)
        }
        
        pendingCardQuantityLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pendingCardLabel.snp.top).offset(-7)
            make.left.equalTo(leftDashboardContainer).offset(20)
            make.right.equalTo(leftDashboardContainer).offset(-20)
        }
        
        pendingCardLabel.snp.makeConstraints { make in
            make.left.equalTo(leftDashboardContainer).offset(20)
            make.right.equalTo(leftDashboardContainer).offset(-20)
            make.bottom.equalTo(leftDashboardContainer).offset(-25)
        }
        
        tableViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerStack.snp.bottom).offset(35)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableViewTitleLabel.snp.bottom).offset(15)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.height.equalTo(categories.count * 40)
        }
    }
}
