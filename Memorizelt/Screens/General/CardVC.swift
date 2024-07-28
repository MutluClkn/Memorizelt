//
//  CardVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 17.07.2024.
//

import UIKit
import SnapKit

final class CardVC: UIViewController {

    // MARK: - Buttons
    private let flipButton = MZButton(title: "Flip Card", backgroundColor: Colors.primary)
    private let closeButton = MZImageButton(systemImage: Texts.AddNewCardScreen.closeIcon, tintColor: Colors.accent)
    private let infoButton = MZImageButton(systemImage: Texts.CardScreen.infoIcon, tintColor: Colors.accent)

    // MARK: - Labels
    let titleLabel = MZLabel(text: "", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 25, textColor: Colors.mainTextColor)
    let reviewedLabel = MZLabel(text: Texts.PrototypeTexts.reviewedCardText, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 14, textColor: Colors.mainTextColor)
    let totalLabel = MZLabel(text: Texts.PrototypeTexts.totalCardText, textAlignment: .right, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 14, textColor: Colors.mainTextColor)
    let cardLabel = MZLabel(text: "", textAlignment: .center, numberOfLines: 0, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.background)

    // MARK: - ProgressView
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = Colors.accent
        progressView.trackTintColor = Colors.secondary
        progressView.setProgress(0.2, animated: false)
        return progressView
    }()

    // MARK: - Views
    private let cardView = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let scrollView = MZScrollView()
    private let nextCardView1 = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let nextCardView2 = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)

    // MARK: - Variables
    var flashcards: [Flashcard] = []
    private let frontFont = UIFont(name: Fonts.interBold, size: 50)
    private let backFont = UIFont(name: Fonts.interMedium, size: 20)
    private var isShowingFront = true
    var frontText = "FRONT"
    var backText = "BACK"
    var cardIndex = 0

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        setupCardView()
        setupGestureRecognizers()
        currentQuestionAndAnswer()
        cardLabel.text = frontText
    }

    private func currentQuestionAndAnswer() {
        if !flashcards.isEmpty {
            frontText = flashcards[cardIndex].question!
            backText = flashcards[cardIndex].answer!
        }
    }

    // MARK: - Gesture Recognizers
    private func setupGestureRecognizers() {
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        cardView.addGestureRecognizer(swipeGestureRecognizer)
    }

    @objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: cardView)
        let cardWidth = cardView.frame.width
        cardView.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)

        let rotationStrength = min(translation.x / cardWidth, 1)
        let rotationAngle = (2 * .pi / 16) * rotationStrength
        cardView.transform = CGAffineTransform(rotationAngle: rotationAngle)

        if gesture.state == .ended {
            if abs(translation.x) > cardWidth / 4 {
                UIView.animate(withDuration: 0.3, animations: {
                    if translation.x > 0 {
                        self.cardView.center = CGPoint(x: self.view.frame.width + cardWidth, y: self.cardView.center.y)
                    } else {
                        self.cardView.center = CGPoint(x: -cardWidth, y: self.cardView.center.y)
                    }
                    self.cardView.alpha = 0
                }) { _ in
                    self.cardView.alpha = 1
                    self.cardView.center = self.view.center
                    self.cardView.transform = .identity
                    self.showNextCard()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.cardView.center = self.view.center
                    self.cardView.transform = .identity
                }
            }
        }
    }

    private func showNextCard() {
        if cardIndex < flashcards.count - 1 {
            cardIndex += 1
            currentQuestionAndAnswer()
            cardLabel.text = frontText
            isShowingFront = true
        } else {
            // Handle the end of the deck
        }
    }

    // MARK: - Button Actions
    @objc func flipCard() {
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.isShowingFront {
                self.cardLabel.text = self.backText
                self.cardLabel.font = self.backFont
            } else {
                self.cardLabel.text = self.frontText
                self.cardLabel.font = self.frontFont
            }
        }, completion: nil)
        isShowingFront.toggle()
    }

    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func infoButtonTapped() {
        let alertController = UIAlertController(title: Texts.CardScreen.alerTitle, message: Texts.CardScreen.alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

// MARK: - Setup Card View Extension
extension CardVC {

    private func setupCardView() {
        cardLabel.text = frontText
        cardLabel.font = frontFont

        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(infoButton)
        view.addSubview(progressView)
        view.addSubview(reviewedLabel)
        view.addSubview(totalLabel)
        
        // Setup next card views for stacking effect
        setupNextCardView(nextCardView: nextCardView2, offset: -10)
        setupNextCardView(nextCardView: nextCardView1, offset: -5)
        setupCurrentCardView()

        view.addSubview(flipButton)
        cardView.addSubview(scrollView)
        scrollView.addSubview(cardLabel)

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
            make.height.equalTo(5)
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

        flipButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(150)
            make.height.equalTo(36)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(32)
        }

        cardLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        // Buttons' Target
        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }

    private func setupNextCardView(nextCardView: MZContainerView, offset: CGFloat) {
        view.addSubview(nextCardView)
        nextCardView.backgroundColor = Colors.primary.withAlphaComponent(0.8)
        nextCardView.layer.cornerRadius = 20
        nextCardView.layer.shadowColor = UIColor.black.cgColor
        nextCardView.layer.shadowOpacity = 0.2
        nextCardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        nextCardView.layer.shadowRadius = 10

        nextCardView.snp.makeConstraints { make in
            make.top.equalTo(reviewedLabel.snp.bottom).offset(50 + offset)
            make.left.equalTo(view).offset(30 + offset)
            make.right.equalTo(view).offset(-30 + offset)
            make.height.equalTo(view.snp.height).multipliedBy(0.67).offset(-100)
        }
    }

    private func setupCurrentCardView() {
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowRadius = 20
        cardView.layer.borderColor = Colors.secondary.cgColor
        cardView.layer.borderWidth = 0.5

        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.equalTo(reviewedLabel.snp.bottom).offset(50)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(view.snp.height).multipliedBy(0.67).offset(-100)
        }
    }
}
