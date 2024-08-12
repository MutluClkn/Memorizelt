//
//  UIViewControllerExtension.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 26.07.2024.
//

import UIKit

extension UIViewController {
    //MARK: - UIAlertController
    func alertMessage(alertTitle: String, alertMesssage: String, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: alertTitle, message: alertMesssage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
            completionHandler?()
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Multiple Option Alert Message
    func multiOptAlertMessage(alertTitle: String, alertMessage: String, firstActionTitle: String, secondActionTitle: String, secondActionStyle: UIAlertAction.Style, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstActionTitle, style: .default) { _ in
            completionHandler?()
        }
        let secondAction = UIAlertAction(title: secondActionTitle, style: secondActionStyle)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        
        self.present(alertController, animated: true)
    }
    
    //MARK: - Hide Keyboard
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    //MARK: - Round a Double To Tens
    func roundToTens(_ x : Double) -> Int {
        return 10 * Int((x / 10.0).rounded())
    }
    
    //MARK: - Round To Hundreds
    func roundToHundreds(_ x : Double) -> Int {
        return 100 * Int((x / 100.0).rounded())
    }
    
    //MARK: - Round the text character limit to tens or hundreds
    func roundToFloorTensOrHundreds() -> Int {
        var tempCountHolder: CGFloat = 0
        var roundQuantity: Int = 0
        let maxTxtHeight = view.frame.size.height * 0.5
        
        let chrcLimit = maxTxtHeight * 2.01
        
        if chrcLimit >= 100.0 {
            
            tempCountHolder = chrcLimit
            
            roundQuantity = roundToHundreds(chrcLimit)
            
            if tempCountHolder < CGFloat(roundQuantity) {
                roundQuantity -= 150
            }
            
        } else {
            
            tempCountHolder = chrcLimit
            
            roundQuantity = roundToTens(chrcLimit)
            
            if tempCountHolder < CGFloat(roundQuantity) {
                roundQuantity -= 10
            }
        }
        
        return roundQuantity
    }
}
