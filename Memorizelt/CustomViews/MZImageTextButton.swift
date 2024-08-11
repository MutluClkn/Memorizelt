//
//  MZImageTextButton.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 7.08.2024.
//

import UIKit

class MZImageTextButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(systemImage: String, tintColor: UIColor, title: String? = Texts.PrototypeTexts.backButtonText, bgColor: UIColor? = Colors.clear, cornerRadius: CGFloat? = 0) {
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.image = UIImage(systemName: systemImage)
        configuration.titlePadding = 1
        configuration.imagePadding = 4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.buttonSize = .small
        configuration.baseForegroundColor = tintColor
        configuration.baseBackgroundColor = bgColor
        
        self.layer.cornerRadius = cornerRadius ?? 0
        self.configuration = configuration
        
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
