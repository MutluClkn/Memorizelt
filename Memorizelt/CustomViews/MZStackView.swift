//
//  MZStackView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 27.07.2024.
//

import UIKit

class MZStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(axis: NSLayoutConstraint.Axis, distribution: Distribution, spacing: CGFloat) {
        super.init(frame: .zero)
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
}
