//
//  CardVC.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 17.07.2024.
//

import UIKit
import SnapKit

class CardVC: UIViewController {
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    let cardLabel = UILabel()
    
    var viewHeight : CGFloat = 0.0
    var viewWidth : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewHeight = view.frame.size.height
        viewWidth = view.frame.size.width
        setupCardView()
    }
    
    func setupCardView() {
        
        print(viewWidth)
        
        cardView.frame = CGRect(x: 50, y: 200, width: 300, height: 200)
        cardView.backgroundColor = .lightGray
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        view.addSubview(cardView)
        
        cardLabel.frame = cardView.bounds
        cardLabel.textAlignment = .center
        cardLabel.text = "JDSHFSDHF"
        cardLabel.numberOfLines = 0
        cardView.addSubview(cardLabel)
        
    }
}
