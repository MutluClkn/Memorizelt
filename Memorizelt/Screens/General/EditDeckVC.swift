//
//  EditDeckVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 26.07.2024.
//

import UIKit
import CoreData
import SnapKit

final class EditDeckVC: UIViewController {
    
    // UI Elements
    private let cancelButton = MZImageTextButton(systemImage: Texts.EditDeckScreen.cancelIcon, title: Texts.EditDeckScreen.cancelTitle, tintColor: Colors.accent)
    private let categoryTextField = MZTextField(returnKeyType: .done)
    
    private let tableView = MZTableView(isScrollEnabled: true)
    
    // Core Data
    private let coreDataManager = CoreDataManager.shared
    
    // Variables
    var flashcards: [Flashcard] = []
    var category: String?
    var declineTextFieldChange: String?
    
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        configureTableView()
        setupConstraints()
        loadCategoryData()
        createDismissKeyboardTapGesture()
        configureCancelButton()
        
        categoryTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Colors.background
        tableView.backgroundColor = Colors.background
        sortFlashcardsByDate()
        tableView.reloadData()
    }
    
    
    // Sort Flashcards by Date
    private func sortFlashcardsByDate() {
        flashcards.sort { $0.creationDate ?? Date.distantPast > $1.creationDate ?? Date.distantPast }
    }
    
    //Configure Table View
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EditDeckCell.self, forCellReuseIdentifier: Cell.editDeckCell)
    }
    
    //Configure Cancel Button
    private func configureCancelButton() {
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    //Load Category Data
    private func loadCategoryData() {
        categoryTextField.text = category
        declineTextFieldChange = category
    }
    
    //Save Changes for Category Name
    @objc private func saveChanges() {
        guard let newCategoryName = categoryTextField.text, !newCategoryName.isEmpty else {
            return
        }
        
        // Update category in Core Data
        for flashcard in flashcards {
            flashcard.category = newCategoryName
        }
        coreDataManager.saveContext()
        
        // Update local data
        category = newCategoryName
        // Update accepted changed name by the user
        declineTextFieldChange = newCategoryName
        // Update navigationBarTitle name
        self.title = category
        self.categoryTextField.endEditing(true)
    }
    
    // When user change category name, it is going to ask if user is certain to change it.
    private func changeCategoryNameControl() {
        let alertController = UIAlertController(title: "Confirm Deck Name Change", message: "Do you wish to proceed with renaming the deck name?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default){ _ in
            self.saveChanges()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default){ _ in
            self.categoryTextField.text = self.declineTextFieldChange
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true)
    }
}

//MARK: - TableView Delegate/DataSource
extension EditDeckVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.editDeckCell, for: indexPath) as? EditDeckCell else { return UITableViewCell() }
        cell.titleLabel.text = flashcards[indexPath.row].question
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flashcard = flashcards[indexPath.row]
        
        // Navigate to the edit flashcard screen
        let editFlashcardVC = EditFlashcardVC()
        editFlashcardVC.flashcard = flashcard
        editFlashcardVC.delegate = self
        navigationController?.pushViewController(editFlashcardVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let flashcardToDelete = flashcards[indexPath.row]
            flashcards.remove(at: indexPath.row)
            coreDataManager.deleteFlashcard(flashcard: flashcardToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - TextFieldDelegate
extension EditDeckVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.categoryTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeCategoryNameControl()
    }
}

// MARK: - EditFlashcardDelegate
extension EditDeckVC: EditFlashcardDelegate {
    func didUpdateFlashcard() {
        sortFlashcardsByDate()
        tableView.reloadData()
    }
}

extension EditDeckVC {
    
    //Setup Constraints
    private func setupConstraints() {
        view.addSubview(cancelButton)
        view.addSubview(categoryTextField)
        view.addSubview(tableView)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(90)
        }
        
        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.height.equalTo(32)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryTextField.snp.bottom).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
        
    }
    
}
