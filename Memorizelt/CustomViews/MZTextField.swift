//
//  MZTextField.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 25.07.2024.
//

import UIKit

class MZTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(returnKeyType: UIReturnKeyType) {
        super.init(frame: .zero)
        self.returnKeyType = returnKeyType
        configure()
    }
    
    
    private func configure() {
        layer.cornerRadius = 7
        layer.borderWidth = 1
        layer.borderColor = Colors.primary.cgColor
        
        textColor = Colors.mainTextColor
        tintColor = Colors.mainTextColor
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 14)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 11
        
        autocorrectionType = .no
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
