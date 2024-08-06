//
//  EditDeckCell.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 6.08.2024.
//

import UIKit
import SnapKit

class EditDeckCell: UITableViewCell {

    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.interSemiBold, size: 16)
        label.textColor = Colors.mainTextColor
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

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }

    }

}
