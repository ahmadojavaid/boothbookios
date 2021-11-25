//
//  SignViewController.swift
//  BoothBook
//
//  Created by abbas on 24/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit
import SignaturePad
import SwiftyJSON

class SignViewController: BaseViewController {
    
    weak var bookingVC:BookingPageViewController!
    var booking_id = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signatureView: SignaturePad!
    
    var btnSubmit:UIButton! {
        didSet{
            btnSubmit?.isEnabled = false
            btnSubmit.backgroundColor = .gray
        }
    }

    let textHeader = ["Signer Name", "Signer Title"]
    let textPlaceHolder = ["JOE BLOGGS", "MR"]
    var cells:[UITableViewCell] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signatureView.backgroundColor = #colorLiteral(red: 0.7865531445, green: 0.8384791017, blue: 0.8926391602, alpha: 1)
        signatureView.delegate = self
        self.customBarRightButton(imageName: "edit", selector: #selector(editSignatureForm))
        // Do any additional setup after loading the view.
        configureTableView()
    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        for i in 0...1 {
            let cell = TextFieldCell.getInstance(nibName: "TextFieldCell") as! TextFieldCell
            cell.setData(header: textHeader[i], placeHolder: textPlaceHolder[i])
            cells.append(cell)
        }
        let cell = ButtonCell.getInstance(nibName: "ButtonCell") as! ButtonCell
        cell.configureButton("Submit", selector: #selector(btnSubmitPressed(_:)), target: self)
        btnSubmit = cell.button
        cells.append(cell)
    }
    
    
    @IBAction func clearSignatureBtn(_ sender: Any) {
        signatureView.clear()
        btnSubmit.isEnabled = false
        btnSubmit.backgroundColor = .gray
    }
    
    @objc func editSignatureForm(){
        let vc = EditBookingSignatureViewController(nibName: "EditBookingSignatureViewController", bundle: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension SignViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    @objc func btnSubmitPressed (_ sender: UIButton){
        print("btnSubmitPressed")
        uploadSignature()
    }
}
extension SignViewController {
    func uploadSignature(){
        let key = User.current?.client_key ?? ""
        let secret = User.current?.client_secret ?? ""
        let name = (cells[0] as? TextFieldCell)?.txtFieldContent.text ?? ""
        let title = (cells[1] as? TextFieldCell)?.txtFieldContent.text ?? ""
        
        var image64Encoded = "data:image/png;base64,"
        if let signature = signatureView.getSignature() {
            if let imData = signature.pngData() {
                image64Encoded = image64Encoded + imData.base64EncodedString()
            }
        }
    
        let method = "api/v1/create/signature?key=\(key)&secret=\(secret)&booking_id=\(booking_id)&name=\(name)&title=\(title)"
        
        self.showProgressHud(message: "Uploading...")
        let manager = BaseManager()
        manager.postRequestRowBody(method, parms: nil, header: nil, body: image64Encoded) { [weak self](status, data) in
            guard let self = self else { return }
            self.dismissProgressHud()
            if status.isSuccess, let data = data {
                let json = JSON(data)
                let result = json["result"].stringValue
                //let signature = json["submitted_data"]["signature"].stringValue
                //print("Signature: \(signature)")
                if result == "Success" {
                    self.showAlert(message: "The signature was added successfully", btnTitle: "Ok") {
                        if let signature = self.signatureView.getSignature() {
                            self.bookingVC.btnSignature.setBackgroundImage(signature, for: .normal)
                            self.bookingVC.btnSignature.setTitle("", for: .normal)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            } else {
                self.showAlert(message: status.message, btnTitle: "Ok")
            }
        }
    }
}


extension SignViewController: SignaturePadDelegate {
    
    func didStart() {
        btnSubmit.isEnabled = false
        btnSubmit.backgroundColor = .gray
    }
    
    func didFinish() {
        btnSubmit.isEnabled = true
        btnSubmit.backgroundColor = #colorLiteral(red: 0.1254816651, green: 0.3204021454, blue: 0.5445814729, alpha: 1)
    }
}
