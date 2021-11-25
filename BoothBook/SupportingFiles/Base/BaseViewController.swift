//
//  BaseViewController.swift
//  Movies
//
//  Created by Sarmad on 2/17/19.
//  Copyright © 2019 Sarmad Abbas. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class BaseViewController: UIViewController {
    
    private var toastViews = [UIView]()
    let baseManager = BaseManager()
    var pView:UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - ViewController Methods
    override func loadView() {
        super.loadView()
        //DispatchQueue.main.async {
            self.setupUI()
        //}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setData()
        //NotificationCenter.default.addObserver(self, selector: #selector(networkDidConnect(_:)), name: NSNotification.Name.NetworkDidConnect, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(networkDidDisconnect(_:)), name: NSNotification.Name.NetworkDidDisconnect, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NetworkDidConnect, object: nil)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NetworkDidDisconnect, object: nil)
    }
    /*
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            var topRef = (self.navigationController?.navigationBar.frame.height ?? 0)
            
            if Constants.safeArea.top > 20 {
                topRef = (self.navigationController?.navigationBar.frame.height ?? 0) + 12
            }
            if size.width > size.height {
                topRef = 0
            }
            
            for v in self.toastViews {
                v.frame.size.width = size.width
                v.frame.origin.y = topRef
            }
        }
        var topRef = (self.navigationController?.navigationBar.frame.height ?? 0) + Constants.statusBarHeight
        if size.width > size.height {
            topRef = 0
        }
        for v in self.toastViews {
            v.frame.size.width = size.width
            v.frame.origin.y = topRef
        }
        
    }
    */
    // MARK: - Uitlity Methods

    func setupUI() {
        customeNavigationBar()
    }
    func setData() {
    }
    func didChangeNetwork(status: NetworkStatus) {
    }
    
    func showToast(_ message: String, type toastType: ToastType) {
        
        let topRef = (self.navigationController?.navigationBar.frame.height ?? 0) + Constants.statusBarHeight
        let containerView = UIView(frame: CGRect(x: 0, y: topRef - 30, width: UIScreen.width, height: 30))
        containerView.backgroundColor = toastType.color
        
        let messageLabel = UILabel(frame: CGRect(x: 16, y: 0, width: UIScreen.width - 32, height: 30))
        messageLabel.font = UIFont.OpenSans(ofSize: 16)
        messageLabel.textColor = UIColor.white
        messageLabel.text = message
        containerView.addSubview(messageLabel)
        
        self.view.addSubview(containerView)
        toastViews.append(containerView)
        view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 0.3, animations: {
            containerView.frame.origin.y = topRef
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 4, animations: {
                containerView.frame.origin.y = topRef - 30
            }, completion: { _ in
                containerView.removeFromSuperview()
                if let index = self.toastViews.index(of: containerView) {
                    self.toastViews.remove(at: index)
                }
            })
        }
        
    }
    
    
}

extension BaseViewController {
    @objc private func networkDidConnect(_ sender: Notification) {
        didChangeNetwork(status: .connected)
    }
    @objc private func networkDidDisconnect(_ sender: Notification) {
        didChangeNetwork(status: .disconnected)
    }
    
    func customeNavigationBar() {
        
        let atrib = [NSAttributedString.Key.font: UIFont(name: "OpenSans", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(atrib, for: UIControl.State.normal)
        
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1667007804, green: 0.3525652885, blue: 0.5560093522, alpha: 1)
        //self.navigationController?.navigationBar.addShadow(height: 4.0)
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans", size: 22.0)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            customBarBackButton()
        }
        //            self.hideNavigatinBarBackButtonTitle()
    }
    func customBarBackButton() {
        let image = UIImage(named: "back")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(navigationAction))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func navigationAction (){
        self.navigationController?.popViewController(animated: true)
    }
    
    func customBarLeftButton(imageName:String, selector:Selector) {
        let image = UIImage(named: imageName)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    func customBarRightButton(imageName:String, selector:Selector) {
        let image = UIImage(named: imageName)
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: selector)
        backButton.tintColor = .white
        navigationItem.rightBarButtonItem = backButton
    }
    func isLocationAccess() -> Bool {
        let alert = UIAlertController(title: "Allow \"Polse\" to Access your location?", message: "Location is used to check you in for your class attendence. Go to settings to grant location access", preferredStyle: .alert)
        let actionO = UIAlertAction(title: "Settings", style: .default) { action in
            if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            //if let url = URL(string: "App-prefs:root=LOCATION_SERVICES") {
            //    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //}
        }
        let actionC = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionC)
        alert.addAction(actionO)
        
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            AppDelegate.shared?.getLocation()
            return true
        case .notDetermined:
            AppDelegate.shared?.getLocation()
            return false
        case .denied, .restricted:
            self.present(alert, animated: true, completion: nil)
            return false
        default:
            return true
        }
    }
    
    func showProgress(_ message:String = "Please wait...") {
        pView = UIView(frame: view.frame)
        pView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let label = UILabel()
        pView?.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        pView?.addSubview(label)
        view.addSubview(pView!)
        label.text = message
        label.textAlignment = .center
        label.backgroundColor = .clear
        let constraints = [
            pView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            pView!.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            label.centerYAnchor.constraint(equalTo: pView!.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: pView!.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    func dismissProgress() {
        pView?.removeFromSuperview()
    }
}

/*
// APIs Implementation
extension BaseViewController {
    func getJSON(_ endPoint:String, completion:@escaping (APIResponseStatus, JSON?)->Void){
        self.showProgressHud(message: "Please Wait...")
        //let vc = showProgress("Please Wait...")
        baseManager.getRequest(endPoint, parms: nil, header: nil) { (status, data) in
            //print(String(data: data!, encoding: .utf8) ?? "")
            self.dismissProgressHud()
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true {
                let vm = self.processValidationMessages(dataMsgs: json["Result"])
                msg = (vm.count > 5) ? (msg + "\n" + vm):msg
            }
            let code = json["statusCode"].intValue
            let jsonData = json["Result"]
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonData)
        }
    }
    
    func postRequestJSON(endPoint:String,parms:[String:Any]? ,completion:@escaping (APIResponseStatus, JSON?)->Void) {
        self.showProgressHud(message: "Please Wait...")
        //let vc = showProgress("Please Wait...")
        baseManager.postRequest(endPoint, parms: parms, header: nil) { (status, data) in
            //print(String(data: data!, encoding: .utf8) ?? "")
            self.dismissProgressHud()
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true || msg.contains("Error") == true{
                let vm = self.processValidationMessages(dataMsgs: json["Result"])
                msg = (vm.count > 5) ? (vm):msg
            }
            let code = json["statusCode"].intValue
            let jsonResult = json["Result"]
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonResult)
        }
    }
    
    func getJSONAuth(_ endPoint:String, completion:@escaping (APIResponseStatus, JSON?)->Void) {
        self.showProgressHud(message: "Please Wait...")
        //let vc = showProgress("Please Wait...")
        baseManager.getRequestWithAuth(endPoint) { (status, data) in
            self.dismissProgressHud()
            //print(String(data: data!, encoding: .utf8) ?? "")
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true {
                let vm = self.processValidationMessages(dataMsgs: json["Result"])
                msg = (vm.count > 5) ? (msg + "\n" + vm):msg
            }
            let code = json["statusCode"].intValue
            let jsonData = json["Result"]
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonData)
        }
    }
    
    func postRequestJSONAuth(_ endPoint:String,parms:[String:Any]?, completion:@escaping (APIResponseStatus, JSON?)->Void){
        self.showProgressHud(message: "Please Wait...")
        //let vc = showProgress("Please Wait...")
        baseManager.postRequestWithAuth(endPoint, parameters: parms) { (status
            , data) in
            //print(String(data: data!, encoding: .utf8) ?? "")
            self.dismissProgressHud()
            //self.dismissProgress(vc)
            guard status.isSuccess, let data = data else {
                let aStatus = APIResponseStatus(isSuccess: false, code: status.code, message: status.message)
                completion(aStatus, nil)
                return
            }
            guard let json = try? JSON(data: data) else {
                completion(APIResponseStatus.invalidResponse, nil)
                return
            }
            var msg = json["statusMessage"].stringValue
            if msg.contains("Validation") == true {
                let vm = self.processValidationMessages(dataMsgs: json["Result"])
                msg = (vm.count > 5) ? (msg + "\n" + vm):msg
            }
            let code = json["statusCode"].intValue
            let jsonData = json["Result"]
            completion(APIResponseStatus(isSuccess: code == 1, code: code, message: msg), jsonData)
        }
    }
    
    func processValidationMessages(dataMsgs:JSON) -> String {
        /*
        let messages = Array(dataMsgs.dictionaryValue.values).map { (json) -> String in
            let msg = json.arrayValue[0].stringValue
            return msg
        } */
        let messages = dataMsgs.dictionaryValue
        var message = ""
        
        messages.forEach { (msg) in
            let msgArray = msg.value.arrayValue
            if msgArray.count > 0 {
                message = message + (message.count > 1 ? "\n":"") + msgArray[0].stringValue
            }
        }
        
        return message
    }
}

*/
