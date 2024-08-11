//
//  MZContainerView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 27.07.2024.
//

import UIKit

class MZContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(cornerRadius: CGFloat, bgColor: UIColor, isHidden: Bool? = false) {
        super.init(frame: .zero)
        self.backgroundColor = bgColor
        self.layer.cornerRadius = cornerRadius
        self.isHidden = isHidden ?? false
    }

}
