//
//  LeadCaptureFormViewController.swift
//  BoothBook
//
//  Created by abbas on 26/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit
import SwiftyJSON

class LeadCaptureFormViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let manager = BookingsManager()
    var listMataData:LeadFormSettingsModel! = LeadFormSettingsModel.current
    //var listTextFields:[(String, String, Bool?, Bool?)] = []
    //var aditionalDetail:(String, String, Bool?, Bool?)!
    //var contactPermission:(String, String, Bool?, Bool?)!
    var isContactPermission = false
    
    var permissionCell = 0
    var aditionalCell = 0
    var cellCount = 0
    
    var eventTypes:[EventTypesModel] = [] /// Event Types To be used with lead capture form
    var bookingData = BookingModel()
    
    var tableCells:[UITableViewCell] = []
    
    fileprivate func generateTextCells() {
        
        tableCells = []
        let mData = listMataData.listMataData
        
        // Heading Cell
        let leadCell = LeadFormHeading.getInstance(nibName: "LeadFormHeading") as! LeadFormHeading
        leadCell.setData(image: listMataData.logoImage)
        tableCells.append(leadCell)
        
        // Text Cells
        func addTextCell(_ data: (String, String, Bool?, Bool?)) {
            if data.2 == true {
                let cell = LeadTextCell.getInstance(nibName: "LeadTextCell") as! LeadTextCell
                cell.setData(data, self)
                tableCells.append(cell)
            }
        }
        for id1 in 3...5 {
            for data in mData[id1] {
                addTextCell(data)
            }
        }
        // Aditional Details Cell
        addTextCell(mData[0][0])
        
        // Contact Permission Cell
        if mData[0][1].2 == true {
            let cCell = ContactPermissionCell.getInstance(nibName: "ContactPermissionCell") as! ContactPermissionCell
            cCell.setData(mData[0][1])
            tableCells.append(cCell)
        }

        // Button Cell
        let btnCell = ButtonCell.getInstance(nibName: "ButtonCell") as! ButtonCell
        btnCell.configureButton(listMataData[13].1, selector: #selector(btnSubmit), target: self, bgColor: UIColor.hexStringToUIColor(hex:listMataData[15].1.trimmed))
        btnCell.button.setTitleColor(UIColor.hexStringToUIColor(hex:listMataData[14].1.trimmed), for: .normal)
        tableCells.append(btnCell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.isLogedin()
        self.showAlert(message: "Now entering the lead capture form. Click the top left of your screen to head back to previous page.", btnTitle: "Okay", btnColor: #colorLiteral(red: 0.1254175007, green: 0.3202634454, blue: 0.5485935807, alpha: 1), closeBtn: false) {
        }
        
        self.loadEvenTypes()
        
        /*
         manager.getLeadStatus { (status, leadTypes) in
         if status.isSuccess {
         leadTypes.forEach({ (type) in
         print("Lead Type ID:\(type.id), Label:\(type.label)")
         })
         } else {
         
         }
         }
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listMataData = LeadFormSettingsModel.current
        generateTextCells()
        tableView.reloadData()
        //selectTextFields()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
}

extension LeadCaptureFormViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCells.count //cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableCells[indexPath.row]
        /*
         switch indexPath.row {
         case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: "LeadFormHeading") as! LeadFormHeading
             cell.setData(image: listMataData.logoImage)
             //cell.configureButton("Submit", selector: #selector(btnSubmit), target: self, bgColor: .black)
             return cell
         case tableCells.count + 2: //cellCount - 1:
             let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
             cell.configureButton(listMataData[13].1, selector: #selector(btnSubmit), target: self, bgColor: UIColor.hexStringToUIColor(hex:listMataData[15].1.trimmed))
             cell.button.setTitleColor(UIColor.hexStringToUIColor(hex:listMataData[14].1.trimmed), for: .normal)
             return cell
         case tableCells.count + 1:
             //if contactPermission.2 == true { // Contact Permission Cell
                 //if (indexPath.row == permissionCell) {
                     let cell = tableView.dequeueReusableCell(withIdentifier: "ContactPermissionCell") as! ContactPermissionCell
                     cell.setData(isChecked: isContactPermission, header: contactPermission.1, selector: #selector(btnContactPermission), target: self)
                     return cell
                 //}
             //}
         default:
             /*
             if aditionalDetail.2 == true { //  Aditional Detail Cell
                 if indexPath.row == aditionalCell {
                     let cell = tableView.dequeueReusableCell(withIdentifier: "LeadTextCell") as! LeadTextCell
                     let textHeading = aditionalDetail.1 + (aditionalDetail.3 == true ? "*":"")
                     let text = aditionalDetail.0
                     cell.setData(heading: textHeading, text: text, height: 80, tag: 100, target: self)
                     return cell
                 }
             } // Other Text Field Cells
             let cell = tableView.dequeueReusableCell(withIdentifier: "LeadTextCell") as! LeadTextCell
             let textHeading = listTextFields[indexPath.row].1 + (listTextFields[indexPath.row].3 == true ? "*":"")
             let text = listTextFields[indexPath.row].0
             cell.setData(heading: textHeading, text: text, tag:indexPath.row - 1, target: self)
             return cell
             */
             return tableCells[indexPath.row - 1]
         }
         */
    }
    
    @objc func btnContactPermission(){
        //isContactPermission = !isContactPermission
    }
    
    @objc func btnSubmit(){
        let isValid = self.isDataValid()
        if  isValid.0 {
            //self.showAlert(message: "Thank you, your form has been submitted. Ready to book now.", btnTitle: "Book Now", btnColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), closeBtn: true) {
            //self.bookingDataSerialization()
            //}
            manager.submitLead(bookingData) { status in
                if status.isSuccess {
                    self.showAlert(message: "Thank you, your form has been submitted", btnTitle: "OK")
                } else {
                    self.showAlert(message: status.message, btnTitle: "OK")
                }
            }
            
        } else {
            self.showAlert(message: isValid.1, btnTitle: "OK", btnColor: .black, closeBtn: false, completion: nil)
        }
    }
    
    func isDataValid()->(Bool, String) {
        var errorMessage = ""
        for index in 1...(tableCells.count - 2) {
            if let tCell = tableCells[index] as? LeadTextCell {
                if tCell.isRequired && (tCell.txtField.text?.count ?? 0 == 0) {
                    errorMessage = errorMessage + "\(tCell.lblHeading.text ?? "") is required.\n"
                }
            } else if let cpCell = tableCells[index] as? ContactPermissionCell {
                if cpCell.isRequired && (cpCell.checked == false) {
                    errorMessage = errorMessage + "Please subscribe to mail offers and services."
                }
            }
        }
        if errorMessage.trimmed.count > 0 {
            return (false,errorMessage)
        } else {
            return (true, "")
        }
    }
    
    fileprivate func bookingDataSerialization() {
        let customer:JSON = [
            "first_name" : bookingData.first_name,
            "last_name" : bookingData.last_name,
            "company" : bookingData.company,
            "customer_street_address" : bookingData.street_address,
            "customer_city" : bookingData.city,
            "customer_country" : "", //"United Kingdom"
            "customer_postcode" : bookingData.postcode_customer
        ]
        let staff:JSON = [
            "262" : "", //"Bill"
            "265" : "", //"Ben"
            "written" : "" //"Ben & Bill"
        ]
        let event:JSON = [
            "event_name" : bookingData.event_name,
            "event_time_start" : "", // "68400",
            "event_time_end" : "", //"82800",
            "event_time_start_formatted" : bookingData.event_time_start,
            "event_time_end_formatted" : bookingData.event_time_end,
            "event_date_uk" : "", //"Saturday 26th Jan 2019",
            "event_date_us" : "",  //"Saturday Jan 26th 2019",
            "event_date_iso" : bookingData.event_time_start ]
        let venue:JSON = [
            "venue_name" : bookingData.venue_name,
            "venue_address" : bookingData.venue_address,
            "venue_postcode" : bookingData.venue_postcode,
            "business_country" : "" ] //"United Kingdom"]
        let price:JSON = [
            "total" : "",
            "total_override" : "" ]
        let notes:JSON = [
            "notes_admin" : "", //"spoke to ollie, he wants...",
            "notes_customer" : bookingData.additional_notes ]
        let booking:JSON = ["0":[
            "id" : 0,
            "created" : "", //"1548072960",
            "created_iso" : Date().toString("yyyy-MM-dd HH:mm:ss"),
            "changed" : "", //"1548072960",
            "changed_iso" : "", //"2019-01-21 12:16:00",
            "status" : "", //"Customer Details Confirmed",
            "email" : bookingData.email,
            "phone" : bookingData.telephone,
            "customer": customer,
            "staff": staff,
            "rep" : "", //nil,
            "packages" : "", //"Silver Package (Oval Enclosed Photo Booth)",
            "extras" : "",
            "event" : event,
            "venue" : venue,
            "price" : price,
            "notes" : notes,
            "signature_required" : false
            ]
        ]
        Booking.current?.append(newBooking: booking)
    }
}
/*
extension LeadCaptureFormViewController {
    func selectTextFields(){
        listMataData = LeadFormSettingsModel.current
        listTextFields = []
        var i = 3
        while i < 5 {
            for item in listMataData.listMataData[i] {
                if item.2 == true {
                    var item1 = item
                    item1.0 = ""
                    listTextFields.append(item1)
                }
            }
            i = i + 1
        }
        aditionalDetail = listMataData.listMataData[0][0]
        aditionalDetail.0 = ""
        contactPermission = listMataData.listMataData[0][1]
        cellCount = listTextFields.count + 1
        if aditionalDetail.2 == true {
            aditionalCell = cellCount - 1
            cellCount = cellCount + 1
        }
        if contactPermission.2 == true {
            permissionCell = cellCount - 1
            cellCount = cellCount + 1
        }
        
        tableView.reloadData()
        let bgColor = UIColor.hexStringToUIColor(hex: listMataData[11].1)
        tableView.backgroundColor = bgColor
        view.backgroundColor = bgColor
    }
}
*/
extension LeadCaptureFormViewController {
    fileprivate func loadEvenTypes() {
        self.showProgress()
        manager.getEventTypes { (status, eventTypes) in
            if status.isSuccess {
                self.eventTypes = eventTypes
            } else {
                print("Event Type Status Message: " + status.message)
            }
            self.dismissProgress()
        }
    }
}
