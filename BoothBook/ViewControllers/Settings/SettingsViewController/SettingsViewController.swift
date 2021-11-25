//
//  SettingsViewController.swift
//  BoothBook
//
//  Created by abbas on 26/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let contentList:[(String, String)] = [
        ("Edit Lead Form", "Configure your lead capture form"),
        ("Help","Find out how to use the app"),
        ("Logout","You will need to re-enter your details next time")
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLogedin()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BookingCell", bundle: .main), forCellReuseIdentifier: "BookingCell")
    }
}


extension SettingsViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell") as! BookingCell
        cell.setData(heading: contentList[indexPath.row].0, detail: contentList[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            let vc = EditLeadFormViewController(nibName: "EditLeadFormViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = HelpViewController(nibName: "HelpViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("Log Out")
            UserDefaults.standard.set(false, forKey: "isLogedin")
            self.isLogedin()
        }
    }
}
