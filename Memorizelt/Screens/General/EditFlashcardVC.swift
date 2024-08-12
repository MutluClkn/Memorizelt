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

final class EditFlashcardVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Labels
    private let questionLabel = MZLabel(text: Texts.AddNewCardScreen.questionTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let answerLabel = MZLabel(text: Texts.AddNewCardScreen.answerTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let characterCountLabel = MZLabel(text: "", textAlignment: .right, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 12, textColor: Colors.secondary)
    
    //TextField
    private let questionTextField = MZTextField(returnKeyType: .next)
    
    //Views
    private let answerTextView = MZTextView()
    private let imageSuperView = MZContainerView(cornerRadius: 0, bgColor: .black.withAlphaComponent(0.9))
    private let imageView = MZImageView(isHidden: true, contentMode: .scaleToFill)
    
    //Button
    private let backButton = MZImageTextButton(systemImage: Texts.EditFlashcardScreen.backIcon, tintColor: Colors.accent)
    private let saveButton = MZButton(title: Texts.AddNewCardScreen.saveButtonTitle, backgroundColor: Colors.primary)
    private let photoButton = MZImageButton(systemImage: "photo.on.rectangle.angled", tintColor: Colors.accent, backgrounColor: Colors.clear)
    private let audioButton = MZImageButton(systemImage: "mic.badge.plus", tintColor: Colors.accent, backgrounColor: Colors.clear)
    private let editButton = MZImageTextButton(systemImage: "square.and.pencil", tintColor: .black, title: "Edit", bgColor: Colors.primary, cornerRadius: 16)
    
    
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
        editButton.layer.cornerRadius = 20
        
        maxTextHeight = view.frame.size.height * 0.5
        roundToFloor = roundToFloorTensOrHundreds()
        
        createDismissKeyboardTapGesture()
        setupConstraints()
        loadFlashcardData()
        configureButtons()
        answerTextView.delegate = self
        updateCharacterCountLabel()
        gestureRecognizer()
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
    
    
    //Gesture Recognizer
    private func gestureRecognizer() {
        // Add tap gesture to dismiss image when tapping on the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissImageView))
        imageSuperView.addGestureRecognizer(tapGesture)
    }
    
    //Loads question and answer fields
    private func loadFlashcardData() {
        guard let flashcard = flashcard else {return}
        questionTextField.text = flashcard.question
        answerTextView.text = flashcard.answer
        category = flashcard.category
        
        if let imageData = flashcard.image {
            imageView.image = UIImage(data: imageData)
            imageSuperView.isHidden = true
            imageView.isHidden = true
            editButton.isHidden = true
        }
    }
    
    // Present Image Picker
    private func presentImagePicker() {
        imageView.image = nil
        flashcard?.image = nil
        imageSuperView.isHidden = true
        editButton.isHidden = true
        imageView.isHidden = true
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            flashcard?.image = selectedImage.jpegData(compressionQuality: 0.8)
            imageSuperView.isHidden = false
            imageView.isHidden = false
            editButton.isHidden = false
        }
    }
    
    
    /// MARK: - Configure Back Button
    private func configureButtons() {
        self.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        self.photoButton.addTarget(self, action: #selector(photoButtonDidTap), for: .touchUpInside)
        self.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
    
    
    /// MARK: - Update the character count label
    private func updateCharacterCountLabel() {
        let remainingCharacters = roundToFloor - answerTextView.text.count
        characterCountLabel.text = "\(remainingCharacters) characters left"
    }
    
    
    ///MARK: - Button Actions
    // Photo Button Did Tap
    @objc private func photoButtonDidTap() {
        guard let flashcard = flashcard, let imageData = flashcard.image else { return }
        imageSuperView.isHidden = false
        imageView.isHidden = false
        imageView.image = UIImage(data: imageData)
        
        self.editButton.isHidden = false
        
        // Animate image appearance
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
            self.imageView.alpha = 1.0
            self.imageView.transform = .identity
            self.editButton.alpha = 1.0
            self.editButton.transform = .identity
        }, completion: nil)
    }
    
    //Edit Button Did Tap
    @objc private func editButtonDidTap() {
        let alert = UIAlertController(title: "Edit Image", message: "The current image will be deleted, and you will be redirected to the gallery to select a new one. Do you want to proceed?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.presentImagePicker()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Back Button Did Tap
    @objc private func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    //Save Button Tapped
    @objc private func saveButtonDidTap() {
        guard let flashcard = flashcard else { return }
        flashcard.question = questionTextField.text ?? ""
        flashcard.answer = answerTextView.text ?? ""
        
        coreDataManager.saveContext()
        delegate?.didUpdateFlashcard()
        
        alertMessage(alertTitle: Texts.EditFlashcardScreen.alertTitle, alertMesssage: Texts.EditFlashcardScreen.alertMessage, completionHandler: nil)
    }
    
    //Dismiss ImageView
    @objc private func dismissImageView() {
        // Animate image disappearance
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.imageView.alpha = 0.0
            self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.editButton.alpha = 0.0
            self.editButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.imageSuperView.isHidden = true
            self.editButton.isHidden = true
            self.imageView.isHidden = true
        }
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
        view.addSubview(photoButton)
        view.addSubview(audioButton)
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(answerLabel)
        view.addSubview(answerTextView)
        view.addSubview(characterCountLabel)
        view.addSubview(saveButton)
        view.addSubview(imageSuperView)
        imageSuperView.addSubview(imageView)
        imageSuperView.addSubview(editButton)
        
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        
        photoButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.width.equalTo(25)
        }
        
        audioButton.snp.makeConstraints { make in
            make.centerY.equalTo(photoButton)
            make.right.equalTo(photoButton.snp.left).offset(-20)
            make.height.width.equalTo(25)
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
        
        imageSuperView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(imageSuperView.snp.left)
            make.right.equalTo(imageSuperView.snp.right)
            make.height.equalTo(maxTextHeight)
            make.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(36)
        }
    }
}
