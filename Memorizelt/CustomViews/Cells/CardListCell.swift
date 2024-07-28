//
//  CardListCell.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit
import SnapKit

class CardListCell: UITableViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interSemiBold, size: 16)
        label.textColor = Colors.mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    let pendingLabel : UILabel = {
        let label = UILabel()
        label.textColor = Colors.secondary
        label.textAlignment = .right
        label.font = UIFont(name: Fonts.interSemiBold, size: 17)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Colors.background
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(pendingLabel)
        
        pendingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(pendingLabel.snp.left).offset(-30)
        }
        
    }
    
}
