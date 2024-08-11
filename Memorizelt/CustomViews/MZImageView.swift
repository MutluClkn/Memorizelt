//
//  MZImageView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 11.08.2024.
//

import UIKit

class MZImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(isHidden: Bool) {
        super.init(frame: .zero)
        configure()
        self.isHidden = isHidden
    }
    
    private func configure() {
        self.contentMode = .scaleToFill
        self.backgroundColor = .black.withAlphaComponent(0.9)
        self.isUserInteractionEnabled = true
    }
}
