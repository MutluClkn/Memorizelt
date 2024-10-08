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
    private let photoButton = MZImageButton(systemImage: "", tintColor: Colors.clear, backgrounColor: Colors.clear)//photo.on.rectangle.angled
    private let audioButton = MZImageButton(systemImage: "speaker.wave.2", tintColor: Colors.accent, backgrounColor: Colors.clear)
    private let closeButton = MZImageButton(systemImage: Texts.AddNewCardScreen.closeIcon, tintColor: Colors.accent, backgrounColor: Colors.clear)
    private let infoButton = MZImageButton(systemImage: Texts.CardScreen.infoIcon, tintColor: Colors.accent, backgrounColor: Colors.clear)
    
    // MARK: - Labels
    let titleLabel = MZLabel(text: "", textAlignment: .left, numberOfLines: 1, fontName: Fonts.interBold, fontSize: 25, textColor: Colors.mainTextColor)
    let reviewedLabel = MZLabel(text: Texts.PrototypeTexts.reviewedCardText, textAlignment: .left, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 14, textColor: Colors.mainTextColor)
    let totalLabel = MZLabel(text: Texts.PrototypeTexts.totalCardText, textAlignment: .right, numberOfLines: 1, fontName: Fonts.interRegular, fontSize: 14, textColor: Colors.mainTextColor)
    let questionLabel = MZLabel(text: "", textAlignment: .center, numberOfLines: 0, fontName: Fonts.interBold, fontSize: 36, textColor: Colors.background)
    let answerLabel = MZLabel(text: "", textAlignment: .center, numberOfLines: 0, fontName: Fonts.interMedium, fontSize: 16, textColor: Colors.background)
    
    // MARK: - ProgressView
    private let progressView = MZProgressView(progressTintColor: Colors.accent, trackTintColor: Colors.secondary, progressViewStyle: .default)
    
    // MARK: - Views
    private let cardView = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let nextCardView1 = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let nextCardView2 = MZContainerView(cornerRadius: 20, bgColor: Colors.primary)
    private let animationBgView = UIView()
    private let animationView = LottieAnimationView()
    private let imageSuperView = MZContainerView(cornerRadius: 0, bgColor: .black.withAlphaComponent(0.9), isHidden: true)
    private let flashcardImageView = MZImageView(isHidden: true, contentMode: .scaleToFill)
    private let thumbnailImageView = MZImageView(isHidden: false, contentMode: .scaleAspectFill)
    
    
    // MARK: - Variables
    var flashcards: [Flashcard] = []
    private let coreDataManager = CoreDataManager.shared
    private var isShowingFront = true
    private var maxTextHeight: CGFloat = 0
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
        
        maxTextHeight = view.frame.size.height * 0.5
        
        answerLabel.isHidden = true
        questionLabel.isHidden = false
        
        totalLabel.text = "\(Int(totalCount)) cards"
        progressIncrease = 1 / totalCount
        
        setupCardView()
        setupGestureRecognizers()
        buttonConfiguration()
        configureThumbnailImageView()
        loadThumbnailImage()
    }
    
    private func configureThumbnailImageView() {
        self.thumbnailImageView.clipsToBounds = true
        self.thumbnailImageView.layer.cornerRadius = 5
        self.thumbnailImageView.layer.borderWidth = 1
        self.thumbnailImageView.layer.borderColor = Colors.accent.cgColor
    }
    
    private func currentQuestionAndAnswer() {
        if !flashcards.isEmpty {
            self.questionLabel.text = flashcards[cardIndex].question ?? "Question not available"
            self.answerLabel.text = flashcards[cardIndex].answer ?? "Answer not available"
        }
    }
    
    // MARK: - Load Thumbnail Image
    private func loadThumbnailImage() {
        if let imageData = flashcards[cardIndex].image, let image = UIImage(data: imageData) {
            thumbnailImageView.image = image
        } else {
            thumbnailImageView.backgroundColor = .black
            thumbnailImageView.tintColor = Colors.accent
        }
    }
    
    
    // MARK: - Gesture Recognizers
    private func setupGestureRecognizers() {
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        cardView.addGestureRecognizer(swipeGestureRecognizer)
        
        // Add tap gesture to dismiss image when tapping on the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFlashcardImage))
        imageSuperView.addGestureRecognizer(tapGesture)
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
            
            answerLabel.isHidden = true
            questionLabel.isHidden = false
            
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
        self.photoButton.addTarget(self, action: #selector(showImage), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc private func showImage() {
        guard let imageData = flashcards[cardIndex].image, let image = UIImage(data: imageData) else {
            let alert = UIAlertController(title: "No Image", message: "This flashcard does not have an image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        flashcardImageView.image = image
        imageSuperView.isHidden = false
        flashcardImageView.isHidden = false
        
        // Initial state for animation
        flashcardImageView.alpha = 0.0
        flashcardImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Animate image appearance
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
            self.flashcardImageView.alpha = 1.0
            self.flashcardImageView.transform = .identity
        }, completion: nil)
        
    }
    
    @objc private func dismissFlashcardImage() {
        // Animate image disappearance
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.flashcardImageView.alpha = 0.0
            self.flashcardImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.imageSuperView.isHidden = true
            self.flashcardImageView.isHidden = true
        }
    }
    
    @objc func flipCard() {
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.isShowingFront {
                self.answerLabel.isHidden = false
                self.questionLabel.isHidden = true
            } else {
                self.answerLabel.isHidden = true
                self.questionLabel.isHidden = false
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
        self.answerLabel.isHidden = true
        self.questionLabel.isHidden = false
        self.isShowingFront = true
        
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(infoButton)
        view.addSubview(progressView)
        view.addSubview(reviewedLabel)
        view.addSubview(totalLabel)
        
        // Setup next card views for stacking effect
        setupNextCardView(nextCardView: nextCardView2, offset: 10)
        setupNextCardView(nextCardView: nextCardView1, offset: 5)
        setupCurrentCardView()
        
        view.addSubview(flipButton)
        view.addSubview(thumbnailImageView)
        view.addSubview(audioButton)
        thumbnailImageView.addSubview(photoButton)
        view.addSubview(imageSuperView)
        imageSuperView.addSubview(flashcardImageView)
        cardView.addSubview(questionLabel)
        cardView.addSubview(answerLabel)
        
        
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
        
        thumbnailImageView.snp.makeConstraints { make in
            make.centerY.equalTo(flipButton)
            make.left.equalTo(flipButton.snp.right).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(40)
        }
        
        photoButton.snp.makeConstraints { make in
            make.edges.equalTo(thumbnailImageView)
        }
        
        audioButton.snp.makeConstraints { make in
            make.centerY.equalTo(flipButton)
            make.right.equalTo(flipButton.snp.left).offset(-20)
            make.width.height.equalTo(30)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(20)
            make.bottom.equalTo(cardView.snp.bottom).offset(-20)
            make.left.equalTo(cardView).offset(20)
            make.right.equalTo(cardView).offset(-20)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(20)
            make.bottom.equalTo(cardView.snp.bottom).offset(-20)
            make.left.equalTo(cardView).offset(20)
            make.right.equalTo(cardView).offset(-20)
        }
        
        imageSuperView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        flashcardImageView.snp.makeConstraints { make in
            make.left.equalTo(imageSuperView.snp.left)
            make.right.equalTo(imageSuperView.snp.right)
            make.height.equalTo(maxTextHeight)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupNextCardView(nextCardView: MZContainerView, offset: CGFloat) {
        view.addSubview(nextCardView)
        nextCardView.backgroundColor = Colors.mainTextColor.withAlphaComponent(0.8)
        nextCardView.layer.cornerRadius = 20
        nextCardView.layer.shadowColor = UIColor.black.cgColor
        nextCardView.layer.shadowOpacity = 0.2
        nextCardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        nextCardView.layer.shadowRadius = 10
        
        nextCardView.snp.makeConstraints { make in
            make.top.equalTo(reviewedLabel.snp.bottom).offset(40 + offset)
            make.left.equalTo(view).offset(40 + offset)
            make.right.equalTo(view).offset(-40 - offset)
            make.height.equalTo(view.snp.height).multipliedBy(0.67).offset(-100)
        }
    }
    
    private func setupCurrentCardView() {
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cardView.layer.shadowRadius = 20
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 0.5
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.equalTo(reviewedLabel.snp.bottom).offset(40)
            make.left.equalTo(view).offset(40)
            make.right.equalTo(view).offset(-40)
            make.height.equalTo(view.snp.height).multipliedBy(0.67).offset(-100)
        }
    }
}
