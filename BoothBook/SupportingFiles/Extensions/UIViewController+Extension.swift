//
//  UIViewController+Extension.swift
//  Sharjah Book Festival
//
//  Created by Zuhair Hussain on 05/03/2018.
//  Copyright © 2018 Zuhair Hussain. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showAlert(message:String, btnTitle:String, btnColor:UIColor? = nil, closeBtn:Bool = false, completion: (()->Void)? = nil){
        let vc = AlertViewController(nibName: "AlertViewController", bundle: .main)
        vc.setData(message: message, isCloseAble: closeBtn, btnTitle: btnTitle, btnColor: btnColor ?? #colorLiteral(red: 0.1254175007, green: 0.3202634454, blue: 0.5485935807, alpha: 1) , completion: completion)
        self.present(vc, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, completion: ((_ action: UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized(), style: .default, handler: completion)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, leftButton: String, rightButton: String, leftCompletion: ((_ action: UIAlertAction) -> Void)? = nil, rightCompletion: ((_ action: UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let leftAction = UIAlertAction(title: leftButton, style: .default, handler: leftCompletion)
        let rightAction = UIAlertAction(title: rightButton, style: .default, handler: rightCompletion)
        alertController.addAction(leftAction)
        alertController.addAction(rightAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addNotificationButton() {
        let notificationButton = UIBarButtonItem(image: #imageLiteral(resourceName: "notification"), style: .plain, target: self, action: #selector(self.openNotificationController(_:)))
        self.navigationItem.rightBarButtonItem = notificationButton
    }
    
    func addLoginButton() {
        let loginButton = UIBarButtonItem(image: #imageLiteral(resourceName: "user_icon"), style: .plain, target: self, action: #selector(self.openLoginController(_:)))
        self.navigationItem.rightBarButtonItem = loginButton
    }
    
    func addLoginAndNotificationButtons() {
        let loginButton = UIBarButtonItem(image: #imageLiteral(resourceName: "user_icon"), style: .plain, target: self, action: #selector(self.openLoginController(_:)))
        loginButton.imageInsets.left = SBLanguage.shared.currentLanguage == "en" ? 16 : -16
        let notificationButton = UIBarButtonItem(image: #imageLiteral(resourceName: "notification"), style: .plain, target: self, action: #selector(self.openNotificationController(_:)))
        self.navigationItem.rightBarButtonItems = [notificationButton, loginButton]
    }
    
    @objc func openLoginController(_ sender: UIBarButtonItem) {
        (UIApplication.shared.delegate as? AppDelegate)?.moveToLoginController()
    }
    @objc func openNotificationController(_ sender: UIBarButtonItem) {
        //let controller = SBNotificationController(nibName: "SBNotificationController", bundle: nil)
        //self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func moveToPreviousController(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func addObserverKeyBoardShow(selector:Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    func addObserverKeyBoardHide(selector:Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func showProgressHud(message:String? = nil) {
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setForegroundColor(.black)
        SVProgressHUD.setRingRadius(12.0)
        SVProgressHUD.show(withStatus: message)
    }
    
    func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    func progressHudShow(message:String? = nil) {
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setFont(UIFont.OpenSans(ofSize: 14))
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setRingRadius(12.0)
        SVProgressHUD.show(withStatus: message)
    }
    
    func progressHudClose() {
        SVProgressHUD.dismiss()
    }
}
