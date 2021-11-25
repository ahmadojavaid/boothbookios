//
//  TextFieldSetupCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class TextFieldSetupCell: UITableViewCell {
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch1BgView: UIView!
    @IBOutlet weak var switch2BgView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    weak var editVC:EditLeadFormViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configureCell(
        placeHolder:String,
        text:String,
        isOn1:Bool,
        isOn2:Bool,
        selector1:Selector,
        selector2:Selector,
        target:Any,
        tag:Int) {
        self.textField.text = text
        self.textField.placeholder = placeHolder
        switch1.isOn = isOn1
        switch2.isOn = isOn2
        customSwitch1(isOn: isOn1)
        customSwitch2(isOn: isOn2)
        switch1.addTarget(target, action: selector1, for: .valueChanged)
        switch2.addTarget(target, action: selector2, for: .valueChanged)
        self.switch1.tag = tag
        self.switch2.tag = tag
        self.tag = tag
        editVC = target as? EditLeadFormViewController
    }
    
    
    @IBAction func switch1(_ sender: Any) {
        DispatchQueue.main.async {
            self.customSwitch1(isOn: self.switch1.isOn)
        }
    }
    
    @IBAction func switch2ValueChange(_ sender: Any) {
        DispatchQueue.main.async {
            self.customSwitch2(isOn: self.switch2.isOn)
        }
    }
    
    func customSwitch1(isOn:Bool){
        if isOn {
            switch1.thumbTintColor = #colorLiteral(red: 0.1254175007, green: 0.3202634454, blue: 0.5485935807, alpha: 1)
            switch1BgView.backgroundColor = #colorLiteral(red: 0.4090108871, green: 0.5859879851, blue: 0.7275733352, alpha: 1)
        } else {
            switch1.thumbTintColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
            switch1BgView.backgroundColor = #colorLiteral(red: 0.7999122739, green: 0.8000505567, blue: 0.799903512, alpha: 1)
        }
    }
    
    func customSwitch2(isOn:Bool){
        if isOn {
            switch2.thumbTintColor = #colorLiteral(red: 0.1254175007, green: 0.3202634454, blue: 0.5485935807, alpha: 1)
            switch2BgView.backgroundColor = #colorLiteral(red: 0.4090108871, green: 0.5859879851, blue: 0.7275733352, alpha: 1)
        } else {
            switch2.thumbTintColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
            switch2BgView.backgroundColor = #colorLiteral(red: 0.7999122739, green: 0.8000505567, blue: 0.799903512, alpha: 1)
        }
    }
    
}
extension TextFieldSetupCell:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        editVC?.listMataData[tag].1 = textField.text ?? ""
    }
}
