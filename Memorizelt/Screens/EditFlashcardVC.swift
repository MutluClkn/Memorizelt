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

class EditFlashcardVC: UIViewController {
    
    //Labels
    private let questionLabel = MZLabel(text: "Question", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    
    private let answerLabel = MZLabel(text: "Answer", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: .white)
    
    //TextField
    private let questionTextField = MZTextField(returnKeyType: .next)
    
    
    //TextView
    private let answerTextView = MZTextView()
    
    //Button
    private let saveButton = MZButton(title: "Save", backgroundColor: UIColor(hex: "#333B4C"))
    
    
    //Variables
    var flashcard : Flashcard?
    var category : String?
    private let coreDataManager = CoreDataManager.shared
    weak var delegate: EditFlashcardDelegate?
    
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createDismissKeyboardTapGesture()
        setupConstraints()
        loadFlashcardData()
    }
    
    //Loads question and answer fields
    private func loadFlashcardData() {
        guard let flashcard = flashcard else {return}
        questionTextField.text = flashcard.question
        answerTextView.text = flashcard.answer
        category = flashcard.category
    }
    
    //Save Button Tapped
    @objc func saveButtonTapped() {
        
        
        guard let flashcard = flashcard else { return }
        flashcard.question = questionTextField.text ?? ""
        flashcard.answer = answerTextView.text ?? ""
        
        coreDataManager.saveContext()
        delegate?.didUpdateFlashcard()
        
        alertMessage(alertTitle: "Success", alertMesssage: "Success", completionHandler: nil)
        
    }
    
}

extension EditFlashcardVC {
    private func setupConstraints() {
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(answerLabel)
        view.addSubview(answerTextView)
        view.addSubview(saveButton)
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
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
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(answerTextView.snp.bottom).offset(30)
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.height.equalTo(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
}
