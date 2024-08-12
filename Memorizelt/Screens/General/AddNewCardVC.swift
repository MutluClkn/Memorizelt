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
import Photos

//MARK: - AddNewCardDelegate Protocol
protocol AddNewCardDelegate: AnyObject {
    func didAddNewCard()
}

//MARK: - AddNewCard ViewController
final class AddNewCardVC: UIViewController {
    
    /// MARK: - UI Elements
    
    private let photoButton = MZImageButton(systemImage: "photo.on.rectangle.angled", tintColor: Colors.accent, backgrounColor: Colors.clear)
    private let audioButton = MZImageButton(systemImage: "mic.badge.plus", tintColor: Colors.accent, backgrounColor: Colors.clear)
    
    private let titleLabel = MZLabel(text: Texts.AddNewCardScreen.title, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 30, textColor: Colors.text)
    private let categoryLabel = MZLabel(text: Texts.AddNewCardScreen.categoryTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let questionLabel = MZLabel(text: Texts.AddNewCardScreen.questionTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let answerLabel = MZLabel(text: Texts.AddNewCardScreen.answerTitle, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.mainTextColor)
    private let characterCountLabel = MZLabel(text: "", textAlignment: .right, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 12, textColor: Colors.secondary)
    
    private var categoryTextField = MZSearchTextField(returnKeyType: .done, filterStringsArray: [""])
    private let questionTextField = MZTextField(returnKeyType: .next)
    
    private let answerTextView = MZTextView()
    private let saveButton = MZButton(title: Texts.AddNewCardScreen.saveButtonTitle, backgroundColor: Colors.primary)
    
    /// MARK: - Core Data
    private let coreDataManager = CoreDataManager.shared
    private var categories: [String] = []
    private var flashcardsByCategory: [String: [Flashcard]] = [:]
    weak var delegate: AddNewCardDelegate?
    
    /// MARK: - Character and TextView Limit
    private var roundToFloor = 0
    private var maxTextHeight: CGFloat = 0
    
    /// MARK: - Image and Audio
    private var selectedImage: UIImage?
    var selectedAudioURL: URL?
    
    
    /// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        maxTextHeight = view.frame.size.height * 0.5
        roundToFloor = roundToFloorTensOrHundreds()
        
        setupConstraints()
        createDismissKeyboardTapGesture()
        loadCategories()
        buttonsConfigure()
        answerTextView.delegate = self
        updateCharacterCountLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
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
    
    
    /// MARK: - Load categories from Core Data
    private func loadCategories() {
        categoryTextField.filterStrings([""])
        flashcardsByCategory = coreDataManager.fetchFlashcardsGroupedByCategory()
        categories = Array(flashcardsByCategory.keys).sorted()
        categoryTextField.filterStrings(categories)
    }
    
    /// MARK: - Buttons Configure
    private func buttonsConfigure() {
        saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(photoButtonDidTap), for: .touchUpInside)
        audioButton.addTarget(self, action: #selector(audioButtonDidTap), for: .touchUpInside)
    }
    
    ///MARK: - Photo Button Tapped
    @objc func photoButtonDidTap() {
        requestPhotoLibraryPermission { granted in
            if granted {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Photo library access denied.")
                
                self.multiOptAlertMessage(alertTitle: "Photo Library Access Required", alertMessage: "Please enable photo library access in Settings to use this feature.", firstActionTitle: "Go to Settings", secondActionTitle: "Cancel", secondActionStyle: .cancel) {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    ///MARK: - Audio Button Tapped
    @objc func audioButtonDidTap() {
        let addAudioVC = AddAudioVC()
        addAudioVC.delegate = self
        addAudioVC.audioTitle = "Audio.m4a"
        if !(categoryTextField.text == "") {
            addAudioVC.audioTitle = categoryTextField.text
        }
        present(addAudioVC, animated: true, completion: nil)
    }
    
    /// MARK: - Save Button Tapped
    @objc func saveButtonDidTap() {
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
        
        // Convert image to Data
        let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
        
        // Convert audio to Data
        let audioData = selectedAudioURL.flatMap { try? Data(contentsOf: $0) }
        
        /// Save flashcard to Core Data
        coreDataManager.addFlashcard(question: question, answer: answer, category: category, image: imageData, audio: audioData)
        
        delegate?.didAddNewCard()
        questionTextField.text = ""
        answerTextView.text = ""
        selectedImage = nil
        selectedAudioURL = nil
        updateCharacterCountLabel() // Reset the character count
        alertMessage(alertTitle: Texts.AddNewCardScreen.alertTitle, alertMesssage: Texts.AddNewCardScreen.alertMessage, completionHandler: nil)
    }
    
    /// MARK: - Update the character count label
    private func updateCharacterCountLabel() {
        let remainingCharacters = roundToFloor - answerTextView.text.count
        characterCountLabel.text = "\(remainingCharacters) characters left"
    }
    
    ///MARK: - Permission To Access Gallery
    private func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("Photo library access granted")
                    completion(true)
                case .denied, .restricted:
                    print("Photo library access denied or not determined")
                    completion(false)
                case .notDetermined:
                    print("Permission not requested yet")
                    self.requestPhotoLibraryPermission(completion: completion)
                case .limited:
                    print("Permission granted but with limited access")
                    completion(true)
                @unknown default:
                    fatalError("Unknown case for PHAuthorizationStatus")
                }
            }
        }
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


//MARK: - UIImagePickerControllerDelegate

extension AddNewCardVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Setup Constraints

extension AddNewCardVC {
    
    /// Setup Constraints
    private func setupConstraints() {
        view.addSubview(photoButton)
        view.addSubview(audioButton)
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
        
        photoButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.width.equalTo(25)
        }
        
        audioButton.snp.makeConstraints { make in
            make.centerY.equalTo(photoButton)
            make.right.equalTo(photoButton.snp.left).offset(-20)
            make.height.width.equalTo(25)
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
