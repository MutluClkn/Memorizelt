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
    private let categoryTextField = MZTextField(returnKeyType: .done)
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // Core Data
    private let coreDataManager = CoreDataManager.shared
    
    // Variables
    var flashcards: [Flashcard] = []
    var category: String?
    var declineTextFieldChange: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupConstraints()
        configureNavigationBar()
        loadCategoryData()
        createDismissKeyboardTapGesture()
        
        categoryTextField.delegate = self
    }
    
    private func setupViews() {
        view.addSubview(categoryTextField)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "flashcardCell")
    }
    
    private func setupConstraints() {
        
        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryTextField.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func configureNavigationBar() {
        title = category
    }
    
    private func loadCategoryData() {
        categoryTextField.text = category
        declineTextFieldChange = category
    }
    
    @objc private func saveChanges() {
        guard let newCategoryName = categoryTextField.text, !newCategoryName.isEmpty else {
            // Show an alert or handle empty category name
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
        let alertController = UIAlertController(title: "Change", message: "Are you sure you want to change the category name?", preferredStyle: .alert)
        
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

extension EditDeckVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashcards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcardCell", for: indexPath)
        cell.textLabel?.text = flashcards[indexPath.row].question
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flashcard = flashcards[indexPath.row]
        
        // Navigate to the edit flashcard screen
        let editFlashcardVC = EditFlashcardVC()
        //editFlashcardVC.flashcard = flashcard
        navigationController?.pushViewController(editFlashcardVC, animated: true)
    }
}


extension EditDeckVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.categoryTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeCategoryNameControl()
    }
}
