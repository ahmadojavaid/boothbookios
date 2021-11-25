//
//  LogInViewController.swift
//  BoothBook
//
//  Created by abbas on 22/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class LogInViewController: BaseViewController {
    
    @IBOutlet weak var txtUrl: UITextField!
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logInDetails = UserLogin()
        txtUrl.text = logInDetails.baseURL
        txtUserName.text = logInDetails.userName
        txtPassword.text = logInDetails.password
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        let valid = validate()
        if !valid.isSuccess {
            self.showAlert(message: valid.message, btnTitle: "OK")
            return
        }
        
        let username = txtUserName.text!
       let finalusername = username.replacingOccurrences(of: " ", with: "%20").trimmed
        UserLogin(userName: finalusername.trimmed, password: txtPassword.text!, baseUrl: txtUrl.text!.trimmed).save()
        let manager = LogInManager()
        manager.logIn(userName: finalusername.trimmed ?? "", password: txtPassword.text ?? "") { (status, user) in
            print("status")
            print(status)
            if status?.isSuccess ?? false {
                user?.save()
                UserDefaults.standard.set(true, forKey: "isLogedin")
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(message: status?.message ?? "Error: Please contact support or try again after few seconds", btnTitle: "OK")
            }
        }
        

        
    }
    
    func validate()->(isSuccess:Bool, message:String){
        if URL(string: txtUrl.text?.trimmed ?? "") == nil {
            return (false, "URL entered is invalid")
        }
        if txtUserName.text?.trimmed.count ?? 0 == 0 {
            return (false, "User name is required")
        }
        if txtPassword.text?.count ?? 0 == 0 {
            return (false, "Password is required")
        }
        
        return (true, "")
    }
    func CHECK_URL(testStr:String) -> Bool
    {
        let emailRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}


