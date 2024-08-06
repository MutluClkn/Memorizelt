// CardVC.swift
// Memorizelt
//
// Created by Mutlu Çalkan on 17.07.2024.
//

import UIKit
import SnapKit
import Lottie

//MARK: - CardDelegate Protocol
protocol CardDelegate: AnyObject {
    func didFinishReviewingFlashcard()
}

//MARK: - CardVC
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
        progressView.setProgress(0.0, animated: false)
        return progressView
    }()
    
    // MARK: - Views
    private let cardView = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let scrollView = MZScrollView()
    private let nextCardView1 = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let nextCardView2 = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let animationBgView = UIView()
    private let animationView = LottieAnimationView()
    
    
    // MARK: - Variables
    var flashcards: [Flashcard] = []
    private let coreDataManager = CoreDataManager.shared
    private let frontFont = UIFont(name: Fonts.interBold, size: 50)
    private let backFont = UIFont(name: Fonts.interMedium, size: 20)
    private var isShowingFront = true
    var frontText = "FRONT"
    var backText = "BACK"
    var cardIndex = 0
    var reviewedCount = 0
    var totalCount: Float = 0.0
    var progressIncrease: Float = 0.0
    var progress: Float = 0.0
    weak var delegate: CardDelegate?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        currentQuestionAndAnswer()
        
        cardLabel.text = frontText
        totalLabel.text = "\(Int(totalCount)) cards"
        progressIncrease = 1 / totalCount
        
        setupCardView()
        setupGestureRecognizers()
        buttonConfiguration()
    }
    
    private func currentQuestionAndAnswer() {
        if !flashcards.isEmpty {
            frontText = flashcards[cardIndex].question ?? "Question not available"
            backText = flashcards[cardIndex].answer ?? "Answer not available"
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
            let didSwipeRight = translation.x > cardWidth / 4
            let didSwipeLeft = translation.x < -cardWidth / 4
            
            if didSwipeRight || didSwipeLeft {
                UIView.animate(withDuration: 0.3, animations: {
                    if didSwipeRight {
                        self.cardView.center = CGPoint(x: self.view.frame.width + cardWidth, y: self.cardView.center.y)
                        self.coreDataManager.updateFlashcardAfterReview(flashcard: self.flashcards[self.cardIndex], correct: true)
                    } else if didSwipeLeft {
                        self.cardView.center = CGPoint(x: -cardWidth, y: self.cardView.center.y)
                        self.coreDataManager.updateFlashcardAfterReview(flashcard: self.flashcards[self.cardIndex], correct: false)
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
            cardLabel.font = frontFont
            reviewedCount += 1
            reviewedLabel.text = "\(reviewedCount) cards reviewed"
            progress += progressIncrease
            progressView.setProgress(progress, animated: true)
            isShowingFront = true
        } else {
            // Notify the delegate that the review session is finished
            delegate?.didFinishReviewingFlashcard()
            
            cardView.layer.opacity = 0
            reviewedCount += 1
            reviewedLabel.text = "\(reviewedCount) cards reviewed"
            progress += progressIncrease
            progressView.setProgress(progress, animated: true)
            
            // Setup and play the animation
            setupAnimation(animationName: "SuccessAnimation", animationViewName: animationView, bgView: animationBgView)
            animationView.play { (finished) in
                if finished {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    //MARK: - Setup Animation
    func setupAnimation(animationName: String, animationViewName: LottieAnimationView, bgView: UIView){
        
        bgView.frame = view.bounds
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        animationViewName.animation = LottieAnimation.named(animationName)
        animationViewName.contentMode = .scaleAspectFit
        animationViewName.loopMode = .playOnce
        animationViewName.animationSpeed = 0.9
        
        view.addSubview(bgView)
        bgView.addSubview(animationViewName)
        
        animationViewName.snp.makeConstraints { make in
            make.centerX.equalTo(bgView)
            make.centerY.equalTo(bgView)
            make.width.equalTo(bgView.snp.width).multipliedBy(0.8)
            make.height.equalTo(bgView.snp.height).multipliedBy(0.45)
        }
    }
    
    //MARK: - Buttons
    private func buttonConfiguration() {
        self.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        self.flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
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
        delegate?.didFinishReviewingFlashcard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func infoButtonTapped() {
        let alertController = UIAlertController(title: Texts.CardScreen.alerTitle, message: Texts.CardScreen.alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
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
        //view.addSubview(animationView)
        
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
            make.edges.equalTo(cardView).inset(20)
        }
        
        cardLabel.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func setupNextCardView(nextCardView: UIView, offset: CGFloat) {
        view.insertSubview(nextCardView, belowSubview: cardView)
        nextCardView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(offset)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(view.snp.height).multipliedBy(0.45)
        }
    }
    
    private func setupCurrentCardView() {
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
    }
}
