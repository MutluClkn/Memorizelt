//
//  EditFlashcardVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 26.07.2024.
//

import UIKit
import SnapKit
import CoreData

protocol EditFlashcardDelegate: AnyObject {
    func didUpdateFlashcard()
}

final class EditFlashcardVC: UIViewController {
    
    //Labels
    private let backButton = MZImageTextButton(systemImage: Texts.EditFlashcardScreen.backIcon, tintColor: Colors.accent)
    private let questionLabel = MZLabel(text: Texts.AddNewCardScreen.questionTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let answerLabel = MZLabel(text: Texts.AddNewCardScreen.answerTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let characterCountLabel = MZLabel(text: "", textAlignment: .right, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 12, textColor: Colors.secondary)
    
    //TextField
    private let questionTextField = MZTextField(returnKeyType: .next)
    
    //TextView
    private let answerTextView = MZTextView()
    
    //Button
    private let saveButton = MZButton(title: Texts.AddNewCardScreen.saveButtonTitle, backgroundColor: Colors.primary)
    
    
    //Variables
    var flashcard: Flashcard?
    var category: String?
    private let coreDataManager = CoreDataManager.shared
    weak var delegate: EditFlashcardDelegate?
    
    /// MARK: - Character and TextView Limit
    private var roundToFloor = 0
    private var maxTextHeight: CGFloat = 0
    
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        maxTextHeight = view.frame.size.height * 0.5
        roundToFloor = roundToFloorTensOrHundreds()
        
        createDismissKeyboardTapGesture()
        setupConstraints()
        loadFlashcardData()
        configureBackButton()
        configureSaveButton()
        answerTextView.delegate = self
        updateCharacterCountLabel()
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
    
    ///MARK: - Trim Text to Fit Max Height
    func trimTextToFitMaxHeight(_ textView: UITextView) -> String? {
        var trimmedText = textView.text
        
        /// Create a loop to trim the text until it fits within the maximum height
        while textView.sizeThatFits(textView.bounds.size).height > maxTextHeight, trimmedText?.isEmpty == false {
            trimmedText?.removeLast()
            textView.text = trimmedText
        }
        
        return trimmedText
    }
    
    
    //Loads question and answer fields
    private func loadFlashcardData() {
        guard let flashcard = flashcard else {return}
        questionTextField.text = flashcard.question
        answerTextView.text = flashcard.answer
        category = flashcard.category
    }
    
    //Configure Back Button
    private func configureBackButton() {
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    //Configure Save Button
    private func configureSaveButton() {
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    
    /// MARK: - Update the character count label
    private func updateCharacterCountLabel() {
        let remainingCharacters = roundToFloor - answerTextView.text.count
        characterCountLabel.text = "\(remainingCharacters) characters left"
        print(answerTextView.text.count)
    }
    
    
    //Back Button Did Tap
    @objc func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    //Save Button Tapped
    @objc func saveButtonTapped() {
        guard let flashcard = flashcard else { return }
        flashcard.question = questionTextField.text ?? ""
        flashcard.answer = answerTextView.text ?? ""
        
        coreDataManager.saveContext()
        delegate?.didUpdateFlashcard()
        
        alertMessage(alertTitle: Texts.EditFlashcardScreen.alertTitle, alertMesssage: Texts.EditFlashcardScreen.alertMessage, completionHandler: nil)
    }
}


//MARK: - UITextViewDelegate
extension EditFlashcardVC: UITextViewDelegate {
    
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



// MARK: - Setup Constraints
extension EditFlashcardVC {
    private func setupConstraints() {
        view.addSubview(backButton)
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(answerLabel)
        view.addSubview(answerTextView)
        view.addSubview(characterCountLabel)
        view.addSubview(saveButton)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        questionTextField.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.left.equalTo(questionLabel)
            make.right.equalTo(questionLabel)
            make.height.equalTo(37)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionTextField.snp.bottom).offset(20)
            make.left.equalTo(questionLabel)
            make.right.equalTo(questionLabel)
        }
        
        answerTextView.snp.makeConstraints { make in
            make.top.equalTo(answerLabel.snp.bottom).offset(10)
            make.left.equalTo(questionLabel)
            make.right.equalTo(questionLabel)
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
