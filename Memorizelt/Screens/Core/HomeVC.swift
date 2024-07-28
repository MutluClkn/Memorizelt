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
final class HomeVC: UIViewController, AddNewCardDelegate {
    
    
    //UI Elements
    private let scrollView = MZScrollView()
    private let contentView = UIView()
    private let dashboardContainer = MZContainerView(cornerRadius: 20, bgColor: Colors.tintColor)
    private let calendarIcon = UIImageView()
    private let dateLabel = MZLabel(text: "", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interSemiBold, fontSize: 15, textColor: Colors.alternativeTextColor)
    private let dashboardTitleLabel = MZLabel(text: Texts.HomeScreen.dashboardTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.alternativeTextColor)
    private let dashboardInfoLabel = MZLabel(text: Texts.PrototypeTexts.dashboardInfo, textAlignment: .left, numberOfLines: 0, fontName: Fonts.interSemiBold, fontSize: 25, textColor: Colors.alternativeTextColor)
    private let separatorLine = MZContainerView(cornerRadius: 0, bgColor: Colors.alternativeTextColor)
    private let pendingCategoriesLabel = MZLabel(text: Texts.PrototypeTexts.pendingCategories, textAlignment: .left, numberOfLines: 0, fontName: Fonts.interMedium, fontSize: 13, textColor: Colors.alternativeTextColor)
    private let tableViewTitleLabel = MZLabel(text: Texts.HomeScreen.tableViewTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 17, textColor: Colors.mainTextColor)
    private let tableView = MZTableView(isScrollEnabled: false)
    private let addCardButton = MZFloatingButton(bgColor: Colors.buttonColor, tintColor: Colors.tintColor, cornerRadius: 35, systemImage: Texts.HomeScreen.plusIcon)
    
    //Variables
    private let coreDataManager = CoreDataManager.shared
    private var flashcardsByCategory: [String: [Flashcard]] = [:]
    private var categories: [String] = []
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.bgColor
        configureView()
        loadFlashcards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFlashcards()
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
        calendarIcon.tintColor = Colors.alternativeTextColor
        calendarIcon.contentMode = .scaleAspectFit
    }
    
    
    //TabBar
    private func configureNavAndTabBar() {
        self.navigationItem.title = Texts.HomeScreen.navigationTitle
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.mainTextColor]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.tintColor = Colors.mainTextColor
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
        
        // Update pending categories label
        pendingCategoriesLabel.text = categories.joined(separator: ", ")
        
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
    
    // Update the height of the table view based on the number of categories
        private func updateTableViewHeight() {
            tableView.snp.updateConstraints { make in
                make.height.equalTo(categories.count == 0 ? 40 : categories.count * 50)
            }
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
        contentView.addSubview(dashboardContainer)
        dashboardContainer.addSubview(dashboardInfoLabel)
        dashboardContainer.addSubview(dashboardTitleLabel)
        dashboardContainer.addSubview(dateLabel)
        dashboardContainer.addSubview(calendarIcon)
        dashboardContainer.addSubview(separatorLine)
        dashboardContainer.addSubview(pendingCategoriesLabel)
        
        
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
        
        pendingCategoriesLabel.snp.makeConstraints { make in
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
            make.height.equalTo(categories.count == 0 ? 40 : categories.count * 50)
        }
    }
}
