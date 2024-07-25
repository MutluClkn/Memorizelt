//
//  MZLabel.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 25.07.2024.
//

import UIKit

class MZLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, textAlignment: NSTextAlignment, numberOfLines: Int, fontName: String, fontSize: CGFloat, textColor: UIColor) {
        super.init(frame: .zero)
        self.text = text
        self.numberOfLines = numberOfLines
        self.font = UIFont(name: fontName, size: fontSize)
        self.textColor = textColor
        self.textAlignment = textAlignment
        
        configure()
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        
        //If the label is way too long to fit screen, three dots (...) will be break the label. Exm. Original: MutluClkn37298943534 / Shown: MutluClkn372...
        lineBreakMode = .byTruncatingTail
        
        translatesAutoresizingMaskIntoConstraints = false
    }

}
