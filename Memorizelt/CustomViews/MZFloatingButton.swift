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
    
    init(bgColor: UIColor, tintColor: UIColor, cornerRadius: CGFloat, systemImage: String) {
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        let configuration = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold, scale: .large)
        let sysImage = UIImage(systemName: systemImage, withConfiguration: configuration)
        self.setImage(sysImage, for: .normal)
        self.backgroundColor = bgColor
        self.tintColor = tintColor
        configure()
    }
    
    private func configure() {
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
