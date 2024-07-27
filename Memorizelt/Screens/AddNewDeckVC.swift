//
//  AddNewDeckVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit
import CoreData
import SnapKit
import SearchTextField

//MARK: - AddNewDeckDelegate Protocol
protocol AddNewDeckDelegate: AnyObject {
    func didAddNewDeck()
}

//MARK: - AddNewDeck ViewController
class AddNewDeckVC: UIViewController {
    
    // UI Elements
    private let closeButton = MZImageButton(systemImage: "xmark", tintColor: .white)
    private let categoryLabel = MZLabel(text: "Category", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    private let questionLabel = MZLabel(text: "Question", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    private let answerLabel = MZLabel(text: "Answer", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    private let categoryTextField = MZSearchTextField(returnKeyType: .done, filterStringsArray: [""])
    private let questionTextField = MZTextField(returnKeyType: .next)
    private let answerTextView = MZTextView()
    private let saveButton = MZButton(title: "Save", backgroundColor: UIColor(hex: "#333B4C"))
    
    // Core Data
    private let coreDataManager = CoreDataManager.shared
    private var categories: [String] = []
    weak var delegate: AddNewDeckDelegate?
    
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraints()
        createDismissKeyboardTapGesture()
        
        loadCategories()
    }
    
    // Load categories from Core Data
    private func loadCategories() {
        let flashcardsByCategory = coreDataManager.fetchFlashcardsGroupedByCategory()
        categories = Array(flashcardsByCategory.keys).sorted()
        categoryTextField.filterStrings(categories)
    }
    
    
    // Save Button Tapped
    @objc func saveButtonTapped() {
        guard let question = questionTextField.text, !question.isEmpty,
              let answer = answerTextView.text, !answer.isEmpty,
              let category = categoryTextField.text, !category.isEmpty else {
            alertMessage(alertTitle: "Error", alertMesssage: "Missing arguments.", completionHandler: nil)
            return
        }
        
        // Save flashcard to Core Data
        coreDataManager.addFlashcard(question: question, answer: answer, category: category)
        delegate?.didAddNewDeck()
        questionTextField.text = ""
        answerTextView.text = ""
        alertMessage(alertTitle: "Success", alertMesssage: "Success", completionHandler: nil)
        loadCategories()
    }
    
    // Setup Constraints
    private func setupConstraints() {
        view.addSubview(closeButton)
        view.addSubview(categoryLabel)
        view.addSubview(categoryTextField)
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(answerLabel)
        view.addSubview(answerTextView)
        view.addSubview(saveButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view).offset(20)
            make.width.height.equalTo(20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(40)
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
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.height.equalTo(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // Close Button Tapped
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}
