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
    
    init(title: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        configure()
    }
    
    private func configure() {
        setTitleColor(Colors.background, for: .normal)
        titleLabel?.font = UIFont(name: Fonts.interMedium, size: 15)
        layer.cornerRadius = 16
        layer.borderWidth = 0.7
        layer.borderColor = Colors.secondary.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

}
