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
    private let separatorLine = MZContainerView(cornerRadius: 0, bgColor: Colors.secondary)
    private let pendingFlashcardsLabel = MZLabel(text: "", textAlignment: .left, numberOfLines: 0, fontName: Fonts.interMedium, fontSize: 14, textColor: Colors.accent)
    private let tableViewTitleLabel = MZLabel(text: Texts.HomeScreen.tableViewTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 17, textColor: Colors.mainTextColor)
    private let tableView = MZTableView(isScrollEnabled: false)
    private let addCardButton = MZFloatingButton(bgColor: Colors.primary, tintColor: Colors.background, cornerRadius: 35, systemImage: Texts.HomeScreen.plusIcon)
    
    // Variables
    private let coreDataManager = CoreDataManager.shared
    private var flashcardsDue: [Flashcard] = []
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
    
    // Load Due Flashcards
    private func loadDueFlashcards() {
        flashcardsDue = coreDataManager.fetchFlashcardsForHome()
        categoriesDue = Array(Set(flashcardsDue.compactMap { $0.category }))
        tableView.reloadData()
        
        // Update dashboard
        if flashcardsDue.count > 0 {
            self.dashboardInfoLabel.text = "You have \(flashcardsDue.count) flashcards to review today."
        } else {
            self.dashboardInfoLabel.text = "All flashcards have been reviewed. Great job!"
        }

        
        
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
            make.height.equalTo(flashcardsDue.isEmpty ? 40 : flashcardsDue.count * 50)
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
        let flashcardsInCategory = flashcardsDue.filter { $0.category == category }
        cell.titleLabel.text = category
        cell.pendingLabel.text = "\(flashcardsInCategory.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoriesDue[indexPath.row]
        let flashcardsInCategory = flashcardsDue.filter { $0.category == category }
        
        DispatchQueue.main.async {
            let vc = CardVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.flashcards = flashcardsInCategory
            vc.titleLabel.text = category
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        contentView.addSubview(tableView)
        contentView.addSubview(dashboardContainer)
        dashboardContainer.addSubview(dashboardInfoLabel)
        dashboardContainer.addSubview(dashboardTitleLabel)
        dashboardContainer.addSubview(dateLabel)
        dashboardContainer.addSubview(calendarIcon)
        dashboardContainer.addSubview(separatorLine)
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
            make.top.greaterThanOrEqualTo(dateLabel.snp.bottom).offset(10)
            make.bottom.equalTo(dashboardInfoLabel.snp.top).offset(-5)
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
        }
        
        dashboardInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(dashboardInfoLabel.snp.bottom).offset(10)
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
            make.height.equalTo(1)
        }
        
        pendingFlashcardsLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(10)
            make.left.equalTo(dashboardContainer).offset(20)
            make.right.equalTo(dashboardContainer).offset(-20)
            make.bottom.equalTo(dashboardContainer).offset(-20)
        }
        
        tableViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dashboardContainer.snp.bottom).offset(35)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableViewTitleLabel.snp.bottom).offset(15)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.height.equalTo(flashcardsDue.count * 50)
        }
    }
}
