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
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?()
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Hide Keyboard
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
