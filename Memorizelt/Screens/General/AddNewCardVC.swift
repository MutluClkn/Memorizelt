//
//  AddNewCardVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit
import CoreData
import SnapKit
import SearchTextField

//MARK: - AddNewCardDelegate Protocol
protocol AddNewCardDelegate: AnyObject {
    func didAddNewCard()
}

//MARK: - AddNewCard ViewController
final class AddNewCardVC: UIViewController {
    
    // UI Elements
    private let titleLabel = MZLabel(text: Texts.AddNewCardScreen.title, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 30, textColor: Colors.text)
    private let categoryLabel = MZLabel(text: Texts.AddNewCardScreen.categoryTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let questionLabel = MZLabel(text: Texts.AddNewCardScreen.questionTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let answerLabel = MZLabel(text: Texts.AddNewCardScreen.answerTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    
    private let categoryTextField = MZSearchTextField(returnKeyType: .done, filterStringsArray: [""])
    private let questionTextField = MZTextField(returnKeyType: .next)
    
    private let answerTextView = MZTextView()
    private let saveButton = MZButton(title: Texts.AddNewCardScreen.saveButtonTitle, backgroundColor: Colors.primary)
    
    // Core Data
    private let coreDataManager = CoreDataManager.shared
    private var categories: [String] = []
    weak var delegate: AddNewCardDelegate?
    
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        setupConstraints()
        createDismissKeyboardTapGesture()
        loadCategories()
        saveButtonConfigure()
    }
    
    // Load categories from Core Data
    private func loadCategories() {
        let flashcardsByCategory = coreDataManager.fetchFlashcardsGroupedByCategory()
        categories = Array(flashcardsByCategory.keys).sorted()
        categoryTextField.filterStrings(categories)
    }
    
    //Save Button Configure
    private func saveButtonConfigure() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // Save Button Tapped
    @objc func saveButtonTapped() {
        guard let question = questionTextField.text, !question.isEmpty,
              let answer = answerTextView.text, !answer.isEmpty,
              let category = categoryTextField.text, !category.isEmpty else {
            alertMessage(alertTitle: "Error", alertMesssage: "Please fill in all fields.", completionHandler: nil)
            return
        }
        
        // Check for duplicate questions in the same category (if required)
        if coreDataManager.doesFlashcardExist(question: question, category: category) {
            alertMessage(alertTitle: Texts.AddNewCardScreen.duplicateAlerTitle, alertMesssage: Texts.AddNewCardScreen.duplicateAlertMessage, completionHandler: nil)
            return
        }

        // Save flashcard to Core Data
        coreDataManager.addFlashcard(question: question, answer: answer, category: category)
        delegate?.didAddNewCard()
        questionTextField.text = ""
        answerTextView.text = ""
        alertMessage(alertTitle: Texts.AddNewCardScreen.alertTitle, alertMesssage: Texts.AddNewCardScreen.alertMessage, completionHandler: nil)
    }
    
    // Setup Constraints
    private func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(categoryLabel)
        view.addSubview(categoryTextField)
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(answerLabel)
        view.addSubview(answerTextView)
        view.addSubview(saveButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.left.equalTo(categoryLabel)
            make.right.equalTo(categoryLabel)
            make.height.equalTo(37)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTextField.snp.bottom).offset(20)
            make.left.equalTo(categoryLabel)
            make.right.equalTo(categoryLabel)
        }
        
        questionTextField.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.left.equalTo(categoryLabel)
            make.right.equalTo(categoryLabel)
            make.height.equalTo(37)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionTextField.snp.bottom).offset(20)
            make.left.equalTo(categoryLabel)
            make.right.equalTo(categoryLabel)
        }
        
        answerTextView.snp.makeConstraints { make in
            make.top.equalTo(answerLabel.snp.bottom).offset(10)
            make.left.equalTo(categoryLabel)
            make.right.equalTo(categoryLabel)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(answerTextView.snp.bottom).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(150)
            make.height.equalTo(36)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
}
