//
//  MZTextView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 26.07.2024.
//

import UIKit

class MZTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.borderColor = Colors.mainTextColor.cgColor
        backgroundColor = Colors.bgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 8.0
        textAlignment = .center
        textColor = Colors.mainTextColor
        font = UIFont.systemFont(ofSize: 14)
        autocorrectionType = .no
        translatesAutoresizingMaskIntoConstraints = false
    }
}
