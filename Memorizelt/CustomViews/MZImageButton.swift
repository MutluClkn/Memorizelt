//
//  MZImageButton.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 25.07.2024.
//

import UIKit

class MZImageButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(systemImage: String, tintColor: UIColor) {
        super.init(frame: .zero)
        setImage(UIImage(systemName: systemImage), for: .normal)
        self.tintColor = tintColor
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }

}
