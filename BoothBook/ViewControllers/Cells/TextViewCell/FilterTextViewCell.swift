//
//  FilterTextViewCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class FilterTextViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldIcon: UIImageView!
    
    var picker:UIDatePicker!
    var pickerView:UIPickerView!
    
    weak var bookingFilterVC:BookingsFilterViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        v.backgroundColor = .clear
        textField.leftViewMode = .always
        textField.leftView = v
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(placeHolder:String, text:String? = nil, iconName:String?, tag:Int = 0) {
        if let icon = iconName {
            fieldIcon.image = UIImage(named: icon)
        } else {
            fieldIcon.isHidden = true
        }
        textField.text = text
        textField.placeholder = placeHolder
        
        self.tag = tag
        switch tag {
        case 0:
            pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            //textField.text = placeHolder
            textField.text = "Is greator than"
            textField.inputView = pickerView
            //textField.isEnabled = false
        case 1:
            picker = UIDatePicker()
            picker.addTarget(self, action: #selector(valueUpdated), for: .valueChanged)
            picker.datePickerMode = .date
            textField.inputView = picker
        default:
            break
        }
    }
    
    @objc func valueUpdated(){
        textField.text = picker.date.toString()
        print(picker.date)
    }
    
}
extension FilterTextViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        bookingFilterVC.textFieldData[self.tag] = textField.text ?? ""
        switch tag {
        case 0:
            textField.text = pickerView.selectedRow(inComponent: 0) == 0 ? "Is greator than":"Is less than"
        case 1:
            textField.text = picker.date.toString()
        default:
            break
        }
    }
}

extension FilterTextViewCell:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row{
        case 0:
            return "Is greator than"
        default:
            return "Is less than"
        }
    }
}
