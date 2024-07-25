//
//  MZFloatingButton.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 25.07.2024.
//

import UIKit

class MZFloatingButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(bgColor: UIColor, cornerRadius: CGFloat, systemImage: String) {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        setImage(UIImage(systemName: systemImage), for: .normal)
        backgroundColor = bgColor
        configure()
    }
    
    private func configure() {
        tintColor = .white
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
