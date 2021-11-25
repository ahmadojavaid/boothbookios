//
//  ThanYouCell.swift
//  BoothBook
//
//  Created by abbas on 26/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class ThanYouCell: UITableViewCell {
    
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var contentHeading: UILabel!
    
    @IBOutlet weak var lblBookButton: UILabel!
   
    @IBOutlet weak var btnVisibility: UISwitch!
    @IBOutlet weak var btnVisibilityBgView: UIView!
    
    @IBOutlet weak var titleBtn: UITextField!
    weak var editVC: EditLeadFormViewController!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        contentText.delegate = self
        titleBtn.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ content:String,_ titleBtn:String, isOn:Bool, selector:Selector, target:Any, tag:Int) {
        contentText.text = content
        self.titleBtn.text = titleBtn
        btnVisibility.addTarget(target, action: selector, for: .valueChanged)
        btnVisibility.tag = tag
        btnVisibility.isOn = isOn
        customSwitch1(isOn: isOn)
        self.tag = tag
        editVC = target as? EditLeadFormViewController
    }
    
    @IBAction func switch1(_ sender: Any) {
        DispatchQueue.main.async {
            self.customSwitch1(isOn: self.btnVisibility.isOn)
        }
    }
    
    func customSwitch1(isOn:Bool){
        if isOn {
            btnVisibility.thumbTintColor = #colorLiteral(red: 0.1254175007, green: 0.3202634454, blue: 0.5485935807, alpha: 1)
            btnVisibilityBgView.backgroundColor = #colorLiteral(red: 0.4090108871, green: 0.5859879851, blue: 0.7275733352, alpha: 1)
        } else {
            btnVisibility.thumbTintColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
            btnVisibilityBgView.backgroundColor = #colorLiteral(red: 0.7999122739, green: 0.8000505567, blue: 0.799903512, alpha: 1)
        }
    }
}
extension ThanYouCell: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        editVC?.listMataData[tag].1 = textField.text ?? ""
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        editVC?.listMataData[tag].0 = textView.text ?? ""
    }
}
