//
//  SearchResultViewController.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
    var bookings:[Booking] = []
    var isGreator:Bool = true
    var bookingID:String = ""
    var date:Date?
    var searchAll:String = ""
    
    /*
    @IBOutlet weak var lbl_isGreator: UILabel!
    @IBOutlet weak var lbl_bookingID: UILabel!
    @IBOutlet weak var lbl_searchAll: UILabel!
    */
    @IBOutlet weak var lbl_bookingCount: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BookingCell", bundle: .main), forCellReuseIdentifier: "BookingCell")
        self.setFields()
    }

    
    fileprivate func setFields() {
        //lbl_isGreator.text = "Is \(isGreator ? "geator":"less") than \(date?.toString("dd/MM/yy") ?? "")"
        //lbl_bookingID.text = bookingID
        //lbl_searchAll.text = searchAll
        lbl_bookingCount.text = "Displaying \(bookings.count) Bookings"
    }
    
}

extension SearchResultViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell") as! BookingCell
        cell.setData(bookings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = BookingPageViewController(nibName: "BookingPageViewController", bundle: .main)
        vc.booking = bookings[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
