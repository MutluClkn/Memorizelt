//
//  MZButton.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 25.07.2024.
//

import UIKit

class MZButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, backgroundColor: UIColor, titleColor: UIColor? = Colors.background) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor ?? Colors.background, for: .normal)
        self.backgroundColor = backgroundColor
        configure()
    }
    
    private func configure() {
        self.titleLabel?.font = UIFont(name: Fonts.interMedium, size: 15)
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 0.7
        self.layer.borderColor = Colors.secondary.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
