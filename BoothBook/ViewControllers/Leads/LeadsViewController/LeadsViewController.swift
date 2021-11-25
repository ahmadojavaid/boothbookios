//
//  LeadsViewController.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class LeadsViewController: BaseViewController {
    
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainterView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLogedin()
        
        lblMessage.text = "Submit a lead throug your lead form to view it here"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LeadsCell", bundle: .main), forCellReuseIdentifier: "LeadsCell")
        self.customBarRightButton(imageName: "search3", selector: #selector(searchInLeads))
        //self.customBarLeftButton(imageName: "sync", selector: #selector(syncAllLeads))
    }
    
    @IBAction func btnApplySearch(_ sender: Any) {
        txtSearch.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.searchInLeads()
        }
    }
    
    @objc func searchInLeads(){
        let isHidden = searchContainterView.isHidden
        let frame = searchContainterView.frame
        let frame2 = CGRect(origin: CGPoint(x: frame.origin.x, y: frame.origin.y - frame.size.height), size: frame.size)
        if isHidden {
            searchContainterView.frame = frame2
            searchContainterView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.searchContainterView.frame = frame
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.searchContainterView.frame = frame2
            }) { (ss) in
                self.searchContainterView.isHidden = true
                self.searchContainterView.frame = frame
            }
        }
    }
    @objc func syncAllLeads(){
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.7639096247, green: 0.7791878172, blue: 0.7791878172, alpha: 1)
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        print("Sync All Pressed")
    }
    
}
extension LeadsViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadsCell")!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = LeadDetailViewController(nibName: "LeadDetailViewController", bundle: .main)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

