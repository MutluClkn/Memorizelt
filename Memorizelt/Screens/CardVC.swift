//
//  CardVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 17.07.2024.
//

import UIKit
import SnapKit

class CardVC: UIViewController {
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interBold, size: 25)
        return label
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        progressView.setProgress(0.2, animated: false) // Example initial progress
        return progressView
    }()
    
    let reviewedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "2 cards reviewed"
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "30 cards"
        return label
    }()
    
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(hex: "#333B4C")
        
        return view
    }()
    
    let cardLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    let hardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Hard", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.borderWidth = 0.7
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 7
        return button
    }()
    
    let normalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Normal", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.borderWidth = 0.7
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 7
        return button
    }()
    
    let easyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Easy", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.borderWidth = 0.7
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 7
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCardView()
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func infoButtonTapped(){
        let alertController = UIAlertController(title: "Button Info", message: "Hard: Indicates difficult questions\nNormal: Indicates medium difficulty questions\nEasy: Indicates easy questions", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupCardView() {
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(cardView)
        view.addSubview(buttonStack)
        view.addSubview(infoButton)
        view.addSubview(progressView)
        view.addSubview(reviewedLabel)
        view.addSubview(totalLabel)
        
        buttonStack.addArrangedSubview(hardButton)
        buttonStack.addArrangedSubview(normalButton)
        buttonStack.addArrangedSubview(easyButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view).offset(20)
            make.width.height.equalTo(30)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(view).offset(-20)
            make.width.height.equalTo(20)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(2)
        }
        
        reviewedLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-20)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(reviewedLabel.snp.bottom).offset(70)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(buttonStack.snp.top).offset(-50)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(35)
        }
        
        
        //Label, Uzun metin yazabilecegim bir seyle degistirecegim. View icerisinde asagi kaydirma da olabilir. Sag ust kosede karti cevirmek icin bu dondurme butonu koyacagim.
        
        /*
         cardView.addSubview(cardLabel)
         
         cardLabel.snp.makeConstraints { make in
             make.edges.equalTo(cardView).inset(20)
         }
         
         cardLabel.text = "Walk"
         */
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
    }
}
