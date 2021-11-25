//
//  BookingPageViewController.swift
//  BoothBook
//
//  Created by abbas on 22/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class BookingPageViewController: BaseViewController {
    
    @IBOutlet weak var emailWidth: NSLayoutConstraint!
    @IBOutlet weak var callWIdth: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    
    var btnSignature:UIButton!
    var booking:Booking!
    
    var discriptionList = [ "Sat, 10th Aug Aug 2019, 6.30pm - 9.30pm @ Harefield Barn", "Wedding", "Retro Pod Digital (The Retro Pod) - Set up and pack down (included), Booth Attendant (included), GestBook", "Harefield Barn, Shute Farm, Shobrooke, Crediton, Devon, Ex17 1BW", "", "They will have a guestbook table. Email when you have completed overlay.", "White writing, green & white theme please", "Confirm Guestbook has been received:", "Signed by MR MARTY SMITH on Sat, 12th of Aug 2019 @ 09:39 PM" ]
    var namesList = ["Alex,", "Kyle Jones,", "Ted"]

    func setUpData(){
        
        let event = Event(&booking[.event])
        let venue = Venue(&booking[.venue])
        let notes = Notes(&booking[.notes])
        //let customer = Customer(&booking[.customer])
        let staff = Staff(&booking[.staff])
        //let price = Price(&booking[.price])
        
        lblHeader.text = "#\(booking[.id].int ?? 0) \(event[.event_name].string ?? "")" // Header
        discriptionList[0] = "\(event[.event_date_uk].string ?? ""),  \(event[.event_time_start_formatted].string ?? "") - \(event[.event_time_end_formatted].string ?? "") @ \(venue[.venue_name].string ?? "None")" // Event Schedule Venue
        discriptionList[1] = "\(event[.event_name].string ?? "")" // Evente Name
        discriptionList[2] = "\(booking[.packages].string ?? "")" // With Camera Icon
        discriptionList[3] = "\(venue[.venue_address].string ?? ""), \(venue[.venue_postcode].string ?? ""), \(venue[.business_country].string ?? "")" // Address
        namesList = ["",  "\(staff[.written].string ?? "")", ""] // Staff
        discriptionList[5] = "\(notes[.notes_admin].string ?? "")" //
        discriptionList[6] = "\(notes[.notes_customer].string ?? "")" //
        discriptionList[6] = "\(booking[.status].string ?? "")" //
        discriptionList[7] = "\(event[.event_name].string ?? "")" //
    }
    let iconsList = ["ic_time", "ic_ballon", "ic_camera", "ic_location", "ic_profile", "ic_pin", "ic_message", "ic_pen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        tableView.register(UINib(nibName: "BookingViewCell", bundle: .main), forCellReuseIdentifier: "BookingViewCell")
        tableView.register(UINib(nibName: "SignatureCell", bundle: .main), forCellReuseIdentifier: "SignatureCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        if booking[.phone].string == nil {
            callWIdth.set(multiplier: 0.00001)
            emailWidth.isActive = false
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnEmail_pressed(_ sender: Any) {
        let mailManager = EmailManager()
        let email = booking[.email].stringValue
        mailManager.sendEmail(target: self, recipientEmail: email, subject: "", body: "")
    }
    
    @IBAction func btnCall_pressed(_ sender: Any) {
        let phone = booking[.phone].stringValue
        if let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension BookingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingViewCell") as! BookingViewCell
        
        switch indexPath.row {
        case 0:
            cell.setDataBold(iconsList[indexPath.row], discriptionList[indexPath.row])
        case 1,2,5,6:
            cell.setDataLight(iconsList[indexPath.row], discriptionList[indexPath.row])
        case 3:
            cell.setDataRegular(iconsList[indexPath.row], discriptionList[indexPath.row])
        case 4:
            cell.setName(iconsList[indexPath.row], namesList)
        case 7:
            cell.setDataLightRegular(iconsList[indexPath.row], discriptionList[indexPath.row], detal2: discriptionList[indexPath.row + 1])
        case 8:
           let cell = tableView.dequeueReusableCell(withIdentifier: "SignatureCell") as! SignatureCell
           cell.signatureButton.addTarget(self, action: #selector(addSignature), for: .touchUpInside) //.target(forAction: #selector(addSignature), withSender: nil)
           btnSignature = cell.signatureButton
           return cell
        default:
            print("Opps invalid case!")
        }
        return cell
    }
    @objc func addSignature(){
        let vc = SignViewController(nibName: "SignViewController", bundle: .main)
        vc.bookingVC = self
        vc.booking_id = booking[.id].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
