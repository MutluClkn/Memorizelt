//
//  CardListCell.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 15.07.2024.
//

import UIKit
import SnapKit

class CardListCell: UITableViewCell {
    
    let image : UIImageView = {
        let image = UIImageView(image: UIImage(systemName:"clock.arrow.circlepath"))
        image.tintColor = Colors.accent
        return image
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interSemiBold, size: 15)
        label.textColor = Colors.mainTextColor
        label.textAlignment = .left
        return label
    }()
    
    let newTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interRegular, size: 11)
        label.text = "New"
        label.textColor = Colors.mainTextColor
        label.textAlignment = .center
        return label
    }()
    
    let newQuantity: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interMedium, size: 14)
        label.text = "0"
        label.textColor = Colors.secondary
        label.textAlignment = .center
        return label
    }()
    
    let pendingTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interRegular, size: 11)
        label.text = "Pending"
        label.textColor = Colors.mainTextColor
        label.textAlignment = .center
        return label
    }()
    
    let pendingQuantity : UILabel = {
        let label = UILabel()
        label.textColor = Colors.accent
        label.text = "0"
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.interMedium, size: 14)
        return label
    }()
    
    let newStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }()
    
    let pendingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        return stack
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
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newStack)
        contentView.addSubview(pendingStack)
        
        newStack.addArrangedSubview(newQuantity)
        newStack.addArrangedSubview(newTitle)
        
        pendingStack.addArrangedSubview(pendingQuantity)
        pendingStack.addArrangedSubview(pendingTitle)
        
        
        image.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(contentView).offset(30)
            make.height.width.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(newStack)
            make.left.equalTo(image.snp.right).offset(5)
        }
        
        newStack.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(pendingStack.snp.left).offset(-30)
        }
        
        pendingStack.snp.makeConstraints { make in
            make.centerY.equalTo(newStack)
            make.right.equalTo(contentView).offset(-30)
        }
    }
}
