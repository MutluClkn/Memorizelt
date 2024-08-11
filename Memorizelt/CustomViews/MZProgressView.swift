//
//  MZProgressView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 11.08.2024.
//

import UIKit

class MZProgressView: UIProgressView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(progressTintColor: UIColor, trackTintColor: UIColor, progressViewStyle: UIProgressView.Style) {
        super.init(frame: .zero)
        configure()
        self.progressViewStyle = progressViewStyle
        self.progressTintColor = progressTintColor
        self.trackTintColor = trackTintColor
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setProgress(0.0, animated: true)
    }
}
