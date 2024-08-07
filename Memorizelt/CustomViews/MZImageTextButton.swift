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
    
    init(systemImage: String, title: String, tintColor: UIColor) {
        super.init(frame: .zero)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.image = UIImage(systemName: systemImage)
        configuration.titlePadding = 1
        configuration.imagePadding = 4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.buttonSize = .small
        configuration.baseForegroundColor = tintColor
        configuration.baseBackgroundColor = UIColor.clear
        
        self.configuration = configuration
        
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
