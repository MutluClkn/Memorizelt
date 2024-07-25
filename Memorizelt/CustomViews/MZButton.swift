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
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name: Fonts.interMedium, size: 14)
        layer.cornerRadius = 7
        backgroundColor = .systemGray6
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.systemGray3.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

}
