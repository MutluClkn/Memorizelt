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
        label.font = UIFont(name: Fonts.interMedium, size: 15)
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
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
        
    }
    

}
