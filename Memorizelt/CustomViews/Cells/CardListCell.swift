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
        label.font = UIFont(name: Fonts.interSemiBold, size: 18)
        label.textColor = Colors.mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    let newTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interRegular, size: 14)
        label.text = "New"
        label.textColor = Colors.mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    let newQuantity: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interMedium, size: 15)
        label.text = "0"
        label.textColor = Colors.secondary
        label.textAlignment = .left
        return label
    }()
    
    let pendingTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interRegular, size: 14)
        label.text = "Pending"
        label.textColor = Colors.mainTextColor
        label.textAlignment = .right
        return label
    }()
    
    let pendingQuantity : UILabel = {
        let label = UILabel()
        label.textColor = Colors.secondary
        label.text = "0"
        label.textAlignment = .right
        label.font = UIFont(name: Fonts.interMedium, size: 15)
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
        contentView.addSubview(newTitle)
        contentView.addSubview(newQuantity)
        contentView.addSubview(pendingTitle)
        contentView.addSubview(pendingQuantity)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(35)
            make.right.equalTo(contentView).offset(-35)
        }
        
        newQuantity.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalTo(newTitle)
            make.bottom.equalTo(newTitle.snp.top).offset(-5)
        }
        
        newTitle.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-15)
            make.left.equalTo(contentView).offset(50)
        }
        
        pendingTitle.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-15)
            make.right.equalTo(contentView).offset(-50)
        }
        
        pendingQuantity.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalTo(pendingTitle)
            make.bottom.equalTo(pendingTitle.snp.top).offset(-5)
        }
    }
    
}
