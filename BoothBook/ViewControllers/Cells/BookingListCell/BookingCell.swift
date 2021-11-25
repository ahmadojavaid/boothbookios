//
//  BookingCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ booking:Booking) {
        
        let event = Event(&booking[.event])
        lblHeading.text = "#\(booking[.id].int ?? 0) \(event[.event_name].string ?? "")"
        lblDetail.text = "\(event[.event_date_uk].string ?? ""),  \(event[.event_time_start_formatted].string ?? "") - \(event[.event_time_end_formatted].string ?? "") @ \(Venue(&booking[.venue])[.venue_name].string ?? "")"
    }
    
    func setData(heading: String, detail: String) {
        lblHeading.text = heading
        lblDetail.text = detail
    }
    
}
