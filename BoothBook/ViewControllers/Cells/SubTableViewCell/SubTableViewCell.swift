//
//  SubTableViewCell.swift
//  BoothBook
//
//  Created by abbas on 27/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class SubTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    weak var superVC:BookingsFilterViewController?
    
    //var selectedBookings:[Booking] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BookingCell", bundle: .main), forCellReuseIdentifier: "BookingCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
extension SubTableViewCell:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superVC?.selectedBookings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell") as! BookingCell
        cell.setData(superVC!.selectedBookings[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        var attributes:[NSAttributedString.Key:Any] = [:]
        attributes[.font] = UIFont.OpenSansSemibold(ofSize: 22.0)
        attributes[.foregroundColor] = UIColor.darkText
        let aString = NSMutableAttributedString(string: "Bookings", attributes: attributes)
        let hView = view as! UITableViewHeaderFooterView
        hView.backgroundColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
        hView.textLabel?.attributedText = aString
        hView.textLabel?.textAlignment = .center
        hView.addShadow(height: -1.0, shadowColor: #colorLiteral(red: 0.6074417203, green: 0.6134559948, blue: 0.6134559948, alpha: 1))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = BookingPageViewController(nibName: "BookingPageViewController", bundle: .main)
        superVC?.navigationController?.pushViewController(vc, animated: true)
    }
}
