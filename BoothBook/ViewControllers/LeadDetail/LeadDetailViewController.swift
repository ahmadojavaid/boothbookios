//
//  LeadDetailViewController.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class LeadDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let discriptionList = [ "Ben Smith, Harefield Co. 0341693434, 073213445. 1 Main Street. Totnes AB1 2CD.", "Sat, 10th Aug Aug 2019, 6.30pm - 9.30pm @ Harefield Barn", "Harefield Barn, Shute Farm, Shobrooke, Crediton, Devon, Ex17 1BW", "They will have a guestbook table. Email when you have completed overlay. White writing, green & white theme please. Confirm Guestbook has been received:", "Signed by MR MARTY SMITH on Sat, 12th of Aug 2019 @ 09:39 PM" ]
    let iconsList = ["ic_profile", "ic_ballon", "ic_location", "ic_pin", "ic_message"]
    let totalCells = 5
    var isSynced = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BookingViewCell", bundle: .main), forCellReuseIdentifier: "BookingViewCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: .main), forCellReuseIdentifier: "ButtonCell")
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: nil)
    }
}

extension LeadDetailViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCells + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == totalCells {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            if isSynced {
                cell.configureButton("Synced", selector: #selector(btnSync), target: self, bgColor: #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1))
            } else {
                cell.configureButton("Sync", selector: #selector(btnSync), target: self)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingViewCell") as! BookingViewCell
        cell.setDataLight(iconsList[indexPath.row], discriptionList[indexPath.row])
        return cell
    }
    
    @objc func btnSync(){
        isSynced = true
        tableView.reloadData()
    }
}
