//
//  CardListCell.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit

class CardListCell: UITableViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.medium, size: 15)
        return label
    }()
    
    let pendingLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.medium, size: 15)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(pendingLabel)
        NSLayoutConstraint.activate([
            pendingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pendingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: pendingLabel.leadingAnchor, constant: -16)
        ])
    }
    
}
