//
//  EditBookingSignatureViewController.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class EditBookingSignatureViewController: BaseViewController {

    @IBOutlet weak var switch1BgView: UIView!
    @IBOutlet weak var switch1: UISwitch!
    
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch2BgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func switch2ValueChanged(_ sender: UISwitch) {
        DispatchQueue.main.async {
            self.customSwitch2(isOn: self.switch2.isOn)
        }
    }
    
    @IBAction func switch1ValueChanged(_ sender: UISwitch) {
        DispatchQueue.main.async {
            self.customSwitch1(isOn: self.switch1.isOn)
        }
    }
    
    func customSwitch1(isOn:Bool){
        if isOn {
            switch1.thumbTintColor = #colorLiteral(red: 0.1254175007, green: 0.3202634454, blue: 0.5485935807, alpha: 1)
            switch1BgView.backgroundColor = #colorLiteral(red: 0.4090108871, green: 0.5859879851, blue: 0.7275733352, alpha: 1)
        } else {
            switch1.thumbTintColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
            switch1BgView.backgroundColor = #colorLiteral(red: 0.7999122739, green: 0.8000505567, blue: 0.799903512, alpha: 1)
        }
    }
    
    func customSwitch2(isOn:Bool){
        if isOn {
            switch2.thumbTintColor = #colorLiteral(red: 0.1254175007, green: 0.3202634454, blue: 0.5485935807, alpha: 1)
            switch2BgView.backgroundColor = #colorLiteral(red: 0.4090108871, green: 0.5859879851, blue: 0.7275733352, alpha: 1)
        } else {
            switch2.thumbTintColor = #colorLiteral(red: 0.9332318306, green: 0.9333917499, blue: 0.933221817, alpha: 1)
            switch2BgView.backgroundColor = #colorLiteral(red: 0.7999122739, green: 0.8000505567, blue: 0.799903512, alpha: 1)
        }
    }
    
}
