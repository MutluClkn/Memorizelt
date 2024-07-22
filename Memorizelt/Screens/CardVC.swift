//
//  CardVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 17.07.2024.
//

import UIKit
import SnapKit

class CardVC: UIViewController {
    
    let flipButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
        button.tintColor = .white
        // button.backgroundColor = UIColor(hex: "#333B4C")
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
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
        label.numberOfLines = 1
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
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let cardLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: Fonts.interMedium, size: 16)
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
        button.titleLabel?.font = UIFont(name: Fonts.interMedium, size: 14)
        button.backgroundColor = .systemGray6
        button.layer.borderWidth = 0.7
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 7
        return button
    }()
    
    let normalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Normal", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.interMedium, size: 14)
        button.backgroundColor = .systemGray6
        button.layer.borderWidth = 0.7
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 7
        return button
    }()
    
    let easyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Easy", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.interMedium, size: 14)
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
        cardLabel.text = frontText
    }
    
    var isShowingFront = true
    let frontText = "Walk" // Example front text
    let backText = """
Where does it come from?
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
"""
    
    @objc func flipCard() {
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.cardLabel.text = self.isShowingFront ? self.backText : self.frontText
        }, completion: nil)
        isShowingFront.toggle()
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
            make.width.height.equalTo(20)
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
            make.height.equalTo(30)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(2)
        }
        
        reviewedLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(10)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(15)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reviewedLabel)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(15)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(reviewedLabel.snp.bottom).offset(50)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(buttonStack.snp.top).offset(-40)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(30)
        }
        
        
        
        cardView.addSubview(flipButton)
        
        flipButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(cardView.snp.top).offset(8)
            make.right.equalTo(cardView.snp.right).offset(-8)
        }
        
        
        cardView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardLabel)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(32)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        cardLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.top.equalTo(contentView)
        }
        
        
        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        
    }
}
