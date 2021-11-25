//
//  AlertViewController.swift
//  BoothBook
//
//  Created by abbas on 27/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class AlertViewController: BaseViewController {
    
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCloseWidth: NSLayoutConstraint!
    
    var completion:(()->Void)?
    var message:String = "Than you, your form has been submitted. Ready to book now?"
    var isCloseAble:Bool = true
    var btnTitle:String? = "Book Now"
    var btnColor:UIColor? //= UIColor.darkText
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.1, alpha: 0.6)
        
        self.lblText.text = message
        if !isCloseAble {
            self.btnCloseWidth.constant = 25
            self.btnClose.isHidden = true
        }
        self.btnAction.setTitle(btnTitle, for: .normal)
        self.btnAction.backgroundColor = btnColor
    }
    
    @IBAction func btnAction(_ sender: Any) {
        //if let completion = completion {
            completion?()
        //} else {
            self.dismiss(animated: true, completion: nil)
        //}
    }
    
    
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setData (message:String, isCloseAble:Bool, btnTitle:String?, btnColor:UIColor?, completion:(()->Void)?){
        self.message = message
        self.isCloseAble = isCloseAble
        self.btnTitle = btnTitle
        self.btnColor = btnColor
        self.completion = completion
    }
}
