//
//  DeckListCell.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 25.07.2024.
//

import UIKit
import SnapKit

class DeckListCell: UITableViewCell {

    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interSemiBold, size: 16)
        label.textColor = Colors.mainTextColor
        return label
    }()
    
    let quantity: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interMedium, size: 15)
        label.text = "0"
        label.textColor = Colors.secondary
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.background
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(quantity)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
        }
        
        quantity.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(contentView).offset(-20)
        }
    }
}
