//
//  HomeVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit
import SnapKit
import CoreData

// MARK: - HomeVC
final class HomeVC: UIViewController, AddNewCardDelegate {
    
    // UI Elements
    private let scrollView = MZScrollView()
    private let contentView = UIView()
    private let dashboardContainer = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let calendarIcon = UIImageView()
    private let dateLabel = MZLabel(text: "", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interSemiBold, fontSize: 15, textColor: Colors.alternativeTextColor)
    private let dashboardTitleLabel = MZLabel(text: Texts.HomeScreen.dashboardTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.alternativeTextColor)
    private let dashboardInfoLabel = MZLabel(text: Texts.PrototypeTexts.dashboardInfo, textAlignment: .left, numberOfLines: 0, fontName: Fonts.interSemiBold, fontSize: 22, textColor: Colors.alternativeTextColor)
    private let dashboardSeparatorLine = MZContainerView(cornerRadius: 0, bgColor: Colors.secondary)
    private let pendingFlashcardsLabel = MZLabel(text: "", textAlignment: .left, numberOfLines: 0, fontName: Fonts.interMedium, fontSize: 12, textColor: Colors.accent)
    private let tableViewTitleLabel = MZLabel(text: Texts.HomeScreen.tableViewTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 17, textColor: Colors.mainTextColor)
    private let tableViewSeparatorLine = MZContainerView(cornerRadius: 0, bgColor: Colors.secondary)
    private let tableView = MZTableView(isScrollEnabled: false)
    private let addCardButton = MZFloatingButton(bgColor: Colors.primary, tintColor: Colors.background, cornerRadius: 35, systemImage: Texts.HomeScreen.plusIcon)
    
    // Variables
    private let coreDataManager = CoreDataManager.shared
    private var flashcardCounts: [String: FlashcardCount] = [:]
    private var flaschardsDue: [Flashcard] = []
    private var categoriesDue: [String] = []
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        configureView()
        loadDueFlashcards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDueFlashcards()
    }
    
    // Configure the initial view setup
    private func configureView() {
        configureTableView()
        configureNavAndTabBar()
        configureAddCardButton()
        setDateLabel()
        configureCalendarIcon()
        setupConstraints()
    }
    
    // Set Date Label
    private func setDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let dateString = dateFormatter.string(from: Date())
        dateLabel.text = dateString
    }
    
    // Configure Calendar Icon
    private func configureCalendarIcon() {
        calendarIcon.image = UIImage(systemName: Texts.HomeScreen.calendarIcon)
        calendarIcon.tintColor = Colors.accent
        calendarIcon.contentMode = .scaleAspectFit
    }
    
    // Configure Navigation and Tab Bar
    private func configureNavAndTabBar() {
        self.navigationItem.title = Texts.HomeScreen.navigationTitle
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.mainTextColor]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.tintColor = Colors.primary
    }
    
    // Group flashcards by category and calculate counts
    private func groupFlashcardsByCategory(newFlashcards: [Flashcard], pendingFlashcards: [Flashcard]) {
        var flashcardCounts: [String: FlashcardCount] = [:]
        
        var total = 0
        
        for flashcard in newFlashcards {
            let category = flashcard.category ?? "Unknown"
            if flashcardCounts[category] == nil {
                flashcardCounts[category] = FlashcardCount(newCount: 0, pendingCount: 0)
            }
            flashcardCounts[category]?.newCount += 1
            total += 1
        }
        
        for flashcard in pendingFlashcards {
            let category = flashcard.category ?? "Unknown"
            if flashcardCounts[category] == nil {
                flashcardCounts[category] = FlashcardCount(newCount: 0, pendingCount: 0)
            }
            flashcardCounts[category]?.pendingCount += 1
            total += 1
        }
        
        // Update dashboard
        if flashcardCounts.count > 0 {
            self.dashboardInfoLabel.text = "You have \(total) flashcards to review today."
        } else {
            self.dashboardInfoLabel.text = "All flashcards have been reviewed. Great job!"
        }
        
        // Filter out categories with zero counts
        self.flashcardCounts = flashcardCounts.filter { $0.value.newCount > 0 || $0.value.pendingCount > 0 }

    }
    
    
    // Load Due Flashcards
    private func loadDueFlashcards() {
        
        let newFlashcards = coreDataManager.fetchNewFlashcards()
        let pendingFlashcards = coreDataManager.fetchPendingFlashcards()
        
        groupFlashcardsByCategory(newFlashcards: newFlashcards, pendingFlashcards: pendingFlashcards)
        
        categoriesDue = Array(flashcardCounts.keys).sorted { category1, category2 in
                let flashcards1 = coreDataManager.fetchNewAndPendingFlashcards(forCategory: category1)
                let flashcards2 = coreDataManager.fetchNewAndPendingFlashcards(forCategory: category2)
                
                guard let date1 = flashcards1.first?.creationDate else { return false }
                guard let date2 = flashcards2.first?.creationDate else { return true }
                
                return date1 < date2
            }

        tableView.reloadData()
        
        // Update pending categories label
        pendingFlashcardsLabel.text = categoriesDue.joined(separator: ", ")
        updateTableViewHeight()
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
            let vc = AddNewCardVC()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    func didAddNewCard() {
        loadDueFlashcards()
    }
    
    // Update the height of the table view based on the number of categories
    private func updateTableViewHeight() {
        tableView.snp.updateConstraints { make in
            make.height.equalTo(flashcardCounts.isEmpty ? 40 : flashcardCounts.count * 74)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesDue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.cardListCell, for: indexPath) as? CardListCell else { return UITableViewCell() }
        
        let category = categoriesDue[indexPath.row]
                let counts = flashcardCounts[category]!
                
                cell.titleLabel.text = category
                cell.newQuantity.text = "\(counts.newCount)"
                cell.pendingQuantity.text = "\(counts.pendingCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoriesDue[indexPath.row]
        let flashcardsForCategory = coreDataManager.fetchNewAndPendingFlashcards(forCategory: category)
        
        DispatchQueue.main.async {
            let vc = CardVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.flashcards = flashcardsForCategory
            vc.titleLabel.text = category
            vc.totalCount = Float(flashcardsForCategory.count)
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: - StudyFlashcardDelegate
extension HomeVC: CardDelegate {
    func didFinishReviewingFlashcard() {
        loadDueFlashcards()
    }
}

// MARK: - Constraints Setup
extension HomeVC {
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(addCardButton)
        contentView.addSubview(tableViewTitleLabel)
        contentView.addSubview(tableViewSeparatorLine)
        contentView.addSubview(tableView)
        contentView.addSubview(dashboardContainer)
        dashboardContainer.addSubview(dashboardInfoLabel)
        dashboardContainer.addSubview(dashboardTitleLabel)
        dashboardContainer.addSubview(dateLabel)
        dashboardContainer.addSubview(calendarIcon)
        dashboardContainer.addSubview(dashboardSeparatorLine)
        dashboardContainer.addSubview(pendingFlashcardsLabel)
        
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
        
        dashboardContainer.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.greaterThanOrEqualTo(view.frame.size.height * 0.25)
        }
        
        calendarIcon.snp.makeConstraints { make in
            make.top.equalTo(dashboardContainer).offset(15)
            make.left.equalTo(dashboardContainer).offset(20)
            make.width.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarIcon)
            make.left.equalTo(calendarIcon.snp.right).offset(5)
        }
        
        dashboardTitleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(dateLabel.snp.bottom).offset(50)
            make.bottom.equalTo(dashboardInfoLabel.snp.top).offset(-5)
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
        }
        
        dashboardInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
        }
        
        dashboardSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(dashboardInfoLabel.snp.bottom).offset(15)
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
            make.height.equalTo(1)
        }
        
        pendingFlashcardsLabel.snp.makeConstraints { make in
            make.top.equalTo(dashboardSeparatorLine.snp.bottom).offset(10)
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
            make.bottom.equalTo(dashboardContainer).offset(-15)
        }
        
        tableViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dashboardContainer.snp.bottom).offset(35)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        tableViewSeparatorLine.snp.makeConstraints { make in
            make.top.equalTo(tableViewTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableViewSeparatorLine.snp.bottom).offset(10)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.height.equalTo(flaschardsDue.count * 50)
        }
    }
}
