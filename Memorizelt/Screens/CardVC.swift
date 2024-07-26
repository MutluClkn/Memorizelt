//
//  CardVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 17.07.2024.
//

import UIKit
import SnapKit

final class CardVC: UIViewController {
    
    //MARK: - Buttons
    private let flipButton = MZFloatingButton(bgColor: UIColor(hex: "#333B4C"),
                                      cornerRadius: 25,
                                      systemImage: "arrow.2.circlepath")
    
    private let hardButton = MZButton(title: "Hard", backgroundColor: .systemGray6)
    
    private let normalButton = MZButton(title: "Normal", backgroundColor: .systemGray6)
    
    private let easyButton = MZButton(title: "Easy", backgroundColor: .systemGray6)
    
    private let closeButton = MZImageButton(systemImage: "xmark",
                                    tintColor: .white)
    
    private let infoButton = MZImageButton(systemImage: "info.circle",
                                   tintColor: .secondaryLabel)
    
    
    
    //MARK: - Labels
    let titleLabel = MZLabel(text: "",
                             textAlignment: .left,
                             numberOfLines: 1,
                             fontName: Fonts.interBold,
                             fontSize: 25,
                             textColor: .white)
    
    let reviewedLabel = MZLabel(text: "2 cards reviewed", //Example initial value
                                textAlignment: .left,
                                numberOfLines: 1,
                                fontName: Fonts.interRegular,
                                fontSize: 14,
                                textColor: .secondaryLabel)
    
    let totalLabel = MZLabel(text: "30 cards", //Example initial value
                             textAlignment: .right,
                             numberOfLines: 1,
                             fontName: Fonts.interRegular,
                             fontSize: 14,
                             textColor: .secondaryLabel)
    
    let cardLabel = MZLabel(text: "",
                            textAlignment: .center,
                            numberOfLines: 0,
                            fontName: Fonts.interMedium,
                            fontSize: 16,
                            textColor: .white)
    
    
    //MARK: - ProgressView
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        progressView.setProgress(0.2, animated: false) // Example initial progress
        return progressView
    }()
    
    
    
    //MARK: - Views
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(hex: "#333B4C")
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    
    
    //MARK: - Variables
    var flashcards: [Flashcard] = []
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCardView()
        currentQuestionAndAnswer()
        cardLabel.text = frontText
    }
    
    private let frontFont = UIFont(name: Fonts.interBold, size: 40) // Font for front side
    private let backFont = UIFont(name: Fonts.interRegular, size: 16) // Font for back side
    
    private var isShowingFront = true
    var frontText = "FRONT"
    var backText = "BACK"
    var cardIndex = 0
    
    
    private func currentQuestionAndAnswer() {
        if !flashcards.isEmpty {
            frontText = flashcards[cardIndex].question!
            backText = flashcards[cardIndex].answer!
        }
    }

    
    //MARK: - Button Actions
    @objc func nextQuestion(){
        if !flashcards.isEmpty, flashcards.count >= cardIndex {
            cardIndex = cardIndex + 1
            print(cardIndex)
        }
    }
    
    @objc func flipCard() {
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.isShowingFront {
                self.cardLabel.text = self.backText
                self.cardLabel.font = self.backFont // Set the back font
            } else {
                self.cardLabel.text = self.frontText
                self.cardLabel.font = self.frontFont // Set the front font
            }
        }, completion: nil)
        isShowingFront.toggle()
    }
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func infoButtonTapped(){
        let alertController = UIAlertController(title: "Button Info", message: "Hard: Indicates difficult questions\nNormal: Indicates medium difficulty questions\nEasy: Indicates easy questions", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}


//MARK: - Setup Card View Extension
extension CardVC {
    
    private func setupCardView() {
        cardLabel.text = frontText
        cardLabel.font = frontFont
        
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)
        view.addSubview(infoButton)
        view.addSubview(progressView)
        view.addSubview(reviewedLabel)
        view.addSubview(totalLabel)
        view.addSubview(cardView)
        cardView.addSubview(scrollView)
        scrollView.addSubview(cardLabel)
        
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
        
        view.addSubview(flipButton)
        
        flipButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(cardView.snp.top).offset(8)
            make.right.equalTo(cardView.snp.right).offset(-8)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(32)
        }
        
        cardLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        //Buttons' Target
        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        easyButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        
    }
}
    
    
    
    
    
    
    

