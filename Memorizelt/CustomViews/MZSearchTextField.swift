//
//  MZSearchTextField.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 27.07.2024.
//

import UIKit
import SearchTextField

class MZSearchTextField: SearchTextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(returnKeyType: UIReturnKeyType, filterStringsArray: [String]) {
        super.init(frame: .zero)
        self.returnKeyType = returnKeyType
        self.filterStrings(filterStringsArray)
        configure()
    }
    
    
    private func configure() {
        maxResultsListHeight = 300
        
        startVisible = true
        
        layer.borderWidth = 1
        layer.cornerRadius = 7
        layer.borderColor = Colors.primary.cgColor
        theme = .darkTheme()
        theme.bgColor = .systemGray5
        theme.font = UIFont.systemFont(ofSize: 14)
        theme.cellHeight = 40
        
        
        textColor = Colors.mainTextColor
        tintColor = Colors.mainTextColor
        textAlignment = .left
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 11
        
        autocorrectionType = .no
        
        translatesAutoresizingMaskIntoConstraints = false
    }

}
