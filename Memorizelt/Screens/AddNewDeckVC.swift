//
//  AddNewDeckVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 21.07.2024.
//

import UIKit
import CoreData
import SnapKit


//MARK: - AddNewDeckDelegate Protocol
protocol AddNewDeckDelegate: AnyObject {
    func didAddNewDeck()
}


//MARK: - AddNewDeck ViewController
class AddNewDeckVC: UIViewController {
    
    //Buttons
    private let closeButton = MZImageButton(systemImage: "xmark", tintColor: .white)
    
    
    //Labels
    private let categoryLabel = MZLabel(text: "Category", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    
    private let questionLabel = MZLabel(text: "Question", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    
    private let answerLabel = MZLabel(text: "Answer", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    
    
    
    //TextFields
    private let categoryTextField = MZTextField()
    
    private let questionTextField = MZTextField()
    
    
    //TextView
    private let answerTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.systemGray2.cgColor
        textView.backgroundColor = .systemGray6
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8.0
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    //Button
    private let saveButton = MZButton(title: "Save")
    
    
    //Variables
    private var flashcards: [Flashcard] = []
    private let coreDataManager = CoreDataManager.shared
    private let cardListVC = CardListVC()
    weak var delegate: AddNewDeckDelegate?
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraints()
        createDismissKeyboardTapGesture()
    }
    
    //Hide Keyboard
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //Close Button Tapped
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    //Save Button Tapped
    @objc func saveButtonTapped() {
        
        guard let question = questionTextField.text, !question.isEmpty,
              let answer = answerTextView.text, !answer.isEmpty,
              let category = categoryTextField.text, !category.isEmpty
        else {
            
            let alertController = UIAlertController(title: "Error", message: "Missing arguments.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            
            return
        }
        
        // Save flashcard to Core Data
        CoreDataManager.shared.addFlashcard(question: question, answer: answer, category: category)
        
        delegate?.didAddNewDeck()
        
        self.dismiss(animated: true)
        
    }
    
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
    
}

extension AddNewDeckVC: UITextFieldDelegate {
    
}
