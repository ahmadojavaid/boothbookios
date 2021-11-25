//
//  LeadTextCell.swift
//  BoothBook
//
//  Created by abbas on 04/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class LeadTextCell: UITableViewCell {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    
    var isRequired = false
    
    weak var leadFormVC:LeadCaptureFormViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtField.delegate = self
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(_ data:(String, String, Bool?, Bool?),_ target:LeadCaptureFormViewController? = nil){
        lblHeading.text = data.0 + (data.3 == true ? "*":"")
        isRequired = data.3 ?? false
        
        if data.1.contains("Notes") {
            textFieldHeight.constant = 80
        }
        //else if data.1.contains("Event Type") {
        self.leadFormVC = target
        //}
    }
    
    func setData(heading:String, text:String, height:CGFloat = 40, tag:Int = 0, target:LeadCaptureFormViewController? = nil){
        lblHeading.text = heading
        txtField.text = text
        textFieldHeight.constant = height
        self.tag = tag
        txtField.tag = tag
        leadFormVC = target
        //syncBackData(txtField)
    }
}

extension LeadTextCell:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let text = lblHeading.text ?? "None"
        if text.contains("Email") {
            textField.keyboardType = .emailAddress
        } else if "Telephone* Mobile Phone*".contains(text) {
            textField.keyboardType = .phonePad
        } else if text.contains("Post Code") {
            textField.keyboardType = .numberPad
        } else if text.contains("Event Type"){
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            txtField.inputView = pickerView
        } else if text.contains("Time") {
            // Time Picker
            let datePicker = UIDatePicker()
            datePicker.date = Date()
            self.txtField.text = Date().toString("hh:mm a dd/MM/yyyy")
            datePicker.datePickerMode = .dateAndTime
            //datePicker.addTarget(self, action: #selector(pickDate(_:)), for: .valueChanged);
            txtField.inputView = datePicker
        } else if text.contains("Date") {
            // Date Picker
            let datePicker = UIDatePicker()
            datePicker.date = Date()
            self.txtField.text = Date().toString("yyyy-MM-dd")
            datePicker.datePickerMode = .date
            //datePicker.addTarget(self, action: #selector(pickDate(_:)), for: .valueChanged)
            txtField.inputView = datePicker
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = lblHeading.text ?? ""
        syncData(text, textField)
    }
    
    fileprivate func syncData(_ text: String, _ textField: UITextField) {
        if text.contains("First Name") {
            leadFormVC?.bookingData.first_name = textField.text ?? ""
        } else if text.contains("Last Name") {
            leadFormVC?.bookingData.last_name = textField.text ?? ""
        } else if text.contains("Company Name") {
            leadFormVC?.bookingData.company = textField.text ?? ""
        } else if text.contains("Email") {
            leadFormVC?.bookingData.email = textField.text ?? ""
        } else if text.contains("Telephone") {
            leadFormVC?.bookingData.telephone = textField.text ?? ""
        } else if text.contains("Mobile Phone") {
            leadFormVC?.bookingData.mobile_phone_number = textField.text ?? ""
        } else if text.contains("Address") {
            leadFormVC?.bookingData.street_address = textField.text ?? ""
        } else if text.contains("City") {
            leadFormVC?.bookingData.city = textField.text ?? ""
        } else if text.contains("Event Post") {
            leadFormVC?.bookingData.postcode_event = textField.text ?? ""
        } else if text.contains("Customer Post") {
            leadFormVC?.bookingData.postcode_customer = textField.text ?? ""
        } else if text.contains("Event Start") {
            leadFormVC?.bookingData.event_time_start = textField.text ?? ""
        } else if text.contains("Event End") {
            leadFormVC?.bookingData.event_time_end = textField.text ?? ""
        } else if text.contains("Event Type") {
            let row = (textField.inputView as! UIPickerView).selectedRow(inComponent: 0)
            self.txtField.text = leadFormVC?.eventTypes[row].label
            leadFormVC?.bookingData.event_type = leadFormVC?.eventTypes[row].id ?? ""
        } else if text.contains("Event Name") {
            leadFormVC?.bookingData.event_name = textField.text ?? ""
        } else if text.contains("Venue Name") {
            leadFormVC?.bookingData.venue_name = textField.text ?? ""
        } else if text.contains("Venue Address") {
            leadFormVC?.bookingData.venue_address = textField.text ?? ""
        } else if text.contains("Venue Post Code") {
            leadFormVC?.bookingData.venue_postcode = textField.text ?? ""
        } else if text.contains("Aditional") {
            leadFormVC?.bookingData.additional_notes = textField.text ?? ""
        }
    }
}

extension LeadTextCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leadFormVC?.eventTypes.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leadFormVC?.eventTypes[row].label ?? ""
    }
}
