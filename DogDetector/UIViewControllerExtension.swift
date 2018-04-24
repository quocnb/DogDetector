//
//  UIViewControllerExtension.swift
//  DogDetector
//
//  Created by Quoc Nguyen on 2018/04/20.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    struct AlertAction {
        static let cancelAction = AlertAction(title: "Cancel", action: nil)
        static let closeAction = AlertAction(title: "Close", action: nil)
        let title: String
        let action: (() -> Void)?
    }    
}

extension UIViewController {
    func setupAlertView(_ alertVC: UIAlertController) {
        alertVC.view.tintColor = .black
        let subview = alertVC.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15.0
        alertContentView.clipsToBounds = true
    }
    
    func showAlert(_ title: String, message: String, actions: [AlertAction]) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        setupAlertView(alertView)
        actions.forEach { (action) in
            let alertViewAction = UIAlertAction(title: action.title, style: .default, handler: { (_) in
                action.action?()
            })
            alertView.addAction(alertViewAction)
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ title: String, message: String) {
        let cancelAction = AlertAction.closeAction
        self.showAlert(title, message: message, actions: [cancelAction])
    }
    
    func showPrivacyErrorAlert(title: String?, message: String?) {
        let cancelAction = AlertAction.closeAction
        let openPrivacyAction = AlertAction(title: "Settings") {
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        self.showAlert(title ?? "", message: message ?? "",
                       actions: [cancelAction, openPrivacyAction])
    }
}
