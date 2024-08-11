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
    
    init(systemImage: String, tintColor: UIColor, backgrounColor: UIColor, isHidden: Bool? = false) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: systemImage)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.buttonSize = .small
        configuration.baseForegroundColor = tintColor
        configuration.baseBackgroundColor = backgrounColor
        self.isHidden = isHidden ?? false
        self.configuration = configuration
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }

}
