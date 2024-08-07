//
//  CustomTabBar.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 7.08.2024.
//

import UIKit
import SnapKit

final class CustomTabBar: UITabBar {
    
    private let addCardButton = MZAddCardButton(bgColor: Colors.primary, tintColor: Colors.background, cornerRadius: 32, systemImage: Texts.HomeScreen.plusIcon)
    
    override func draw(_ rect: CGRect) {
        configureShape()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBar()
        setupAddButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Configure
    
    private func setupTabBar() {
        tintColor = Colors.background
        unselectedItemTintColor = UIColor.systemGray2
    }
    
    private func setupAddButton() {
        addSubview(addCardButton)
        addCardButton.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.top)
            make.height.width.equalTo(64)
        }
    }
}

//MARK: - Draw Shape

extension CustomTabBar {
    
    private func configureShape() {
        let path = getTabBarPath()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 2
        shape.strokeColor = Colors.primary.cgColor
        shape.fillColor = Colors.primary.cgColor
        layer.insertSublayer(shape, at: 0)
        
    }
    
    private func getTabBarPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 0))
        
        path.addArc(withCenter: CGPoint(x: frame.width / 2, y: 0),
                    radius: 42,
                    startAngle: .pi,
                    endAngle: .pi * 2,
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
    
}
