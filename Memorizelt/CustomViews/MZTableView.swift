//
//  MZTableView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 28.07.2024.
//

import UIKit

class MZTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(isScrollEnabled: Bool) {
        super.init(frame: .zero, style: .plain)
        self.isScrollEnabled = isScrollEnabled
        configure()
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Colors.background
    }
}
