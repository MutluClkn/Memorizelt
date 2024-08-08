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
    
    /// MARK: - UI Elements
    private let titleLabel = MZLabel(text: Texts.AddNewCardScreen.title, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 30, textColor: Colors.text)
    private let categoryLabel = MZLabel(text: Texts.AddNewCardScreen.categoryTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let questionLabel = MZLabel(text: Texts.AddNewCardScreen.questionTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let answerLabel = MZLabel(text: Texts.AddNewCardScreen.answerTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let characterCountLabel = MZLabel(text: "", textAlignment: .right, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 12, textColor: Colors.secondary)
    
    private let categoryTextField = MZSearchTextField(returnKeyType: .done, filterStringsArray: [""])
    private let questionTextField = MZTextField(returnKeyType: .next)
    
    private let answerTextView = MZTextView()
    private let saveButton = MZButton(title: Texts.AddNewCardScreen.saveButtonTitle, backgroundColor: Colors.primary)
    
    /// MARK: - Core Data
    private let coreDataManager = CoreDataManager.shared
    private var categories: [String] = []
    private var flashcardsByCategory: [String: [Flashcard]] = [:]
    weak var delegate: AddNewCardDelegate?
    
    /// MARK: - Character and TextView Limit
    private var characterLimit: CGFloat = 150
    private var temporaryCountHolder: CGFloat = 0
    private var roundToFloor = 0
    private var maxTextHeight: CGFloat = 50
    
    /// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        maxTextHeight = view.frame.size.height * 0.5
        roundToFloorTensOrHundreds()
        setupConstraints()
        createDismissKeyboardTapGesture()
        loadCategories()
        saveButtonConfigure()
        answerTextView.delegate = self
        updateCharacterCountLabel()
    }
    
    /// MARK: - Round the text character limit to tens or hundreds
    private func roundToFloorTensOrHundreds() {
        self.characterLimit = maxTextHeight * 2.01
        
        if characterLimit >= 100.0 {
            
            self.temporaryCountHolder = characterLimit
            
            self.roundToFloor = roundToHundreds(characterLimit)
            
            if temporaryCountHolder < CGFloat(roundToFloor) {
                roundToFloor -= 150
            }
            
        } else {
            
            self.temporaryCountHolder = characterLimit
            
            self.roundToFloor = roundToTens(characterLimit)
            
            if temporaryCountHolder < CGFloat(roundToFloor) {
                roundToFloor -= 10
            }
        }
    }
    
    /// MARK: - Setting a limit to the text height of TextView. So text will not run off the CardView on card screen.
    func textViewDidChange(_ textView: UITextView) {
        // Calculate the size of the textView's content
        let contentSize = textView.sizeThatFits(textView.bounds.size)
        
        // Check if the content height exceeds the maximum height
        if contentSize.height > maxTextHeight {
            // Trim the text to fit within the maximum height
            textView.text = trimTextToFitMaxHeight(textView)
        }
    }
    
    private func trimTextToFitMaxHeight(_ textView: UITextView) -> String? {
        var trimmedText = textView.text
        
        /// Create a loop to trim the text until it fits within the maximum height
        while textView.sizeThatFits(textView.bounds.size).height > maxTextHeight, trimmedText?.isEmpty == false {
            trimmedText?.removeLast()
            textView.text = trimmedText
        }
        
        return trimmedText
    }
    
    
    /// MARK: - Load categories from Core Data
    private func loadCategories() {
        flashcardsByCategory = coreDataManager.fetchFlashcardsGroupedByCategory()
        categories = Array(flashcardsByCategory.keys).sorted()
        categoryTextField.filterStrings(categories)
    }
    
    /// MARK: - Save Button Configure
    private func saveButtonConfigure() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    /// MARK: - Save Button Tapped
    @objc func saveButtonTapped() {
        guard let question = questionTextField.text, !question.isEmpty,
              let answer = answerTextView.text, !answer.isEmpty,
              let category = categoryTextField.text, !category.isEmpty else {
            alertMessage(alertTitle: "Error", alertMesssage: "Please fill in all fields.", completionHandler: nil)
            return
        }
        
        /// Check for duplicate questions in the same category (if required)
        if coreDataManager.doesFlashcardExist(question: question, category: category) {
            alertMessage(alertTitle: Texts.AddNewCardScreen.duplicateAlerTitle, alertMesssage: Texts.AddNewCardScreen.duplicateAlertMessage, completionHandler: nil)
            return
        }
        
        /// Save flashcard to Core Data
        coreDataManager.addFlashcard(question: question, answer: answer, category: category)
        delegate?.didAddNewCard()
        questionTextField.text = ""
        answerTextView.text = ""
        updateCharacterCountLabel() // Reset the character count
        alertMessage(alertTitle: Texts.AddNewCardScreen.alertTitle, alertMesssage: Texts.AddNewCardScreen.alertMessage, completionHandler: nil)
    }
    
    /// MARK: - Update the character count label
    private func updateCharacterCountLabel() {
        let remainingCharacters = roundToFloor - answerTextView.text.count
        characterCountLabel.text = "\(remainingCharacters) characters left"
    }
}

//MARK: - UITextViewDelegate

extension AddNewCardVC: UITextViewDelegate {
    
    /// UITextViewDelegate method to enforce the character limit
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.count <= roundToFloor {
            updateCharacterCountLabel()
            return true
        } else {
            return false
        }
    }
}


//MARK: - Setup Constraints

extension AddNewCardVC {
    
    /// Setup Constraints
    private func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(categoryLabel)
        view.addSubview(categoryTextField)
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(answerLabel)
        view.addSubview(characterCountLabel)
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
        
        characterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(answerTextView.snp.bottom).offset(10)
            make.right.equalTo(answerTextView.snp.right).offset(-10)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(characterCountLabel.snp.bottom).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(150)
            make.height.equalTo(36)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
}
