//
//  MZScrollView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 27.07.2024.
//

import UIKit

class MZScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    private func configure() {
        self.showsVerticalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
