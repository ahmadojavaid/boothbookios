//
//  ContactPermissionCell.swift
//  BoothBook
//
//  Created by abbas on 06/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class ContactPermissionCell: UITableViewCell {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    var isRequired = false
    //weak var leadFormVC:LeadCaptureFormViewController?
    var checked = false {
        didSet {
            btnCheckBox?.setImage(UIImage(named: checked ? "check":"uncheck"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setData(_ data:(String, String, Bool?, Bool?)){
        self.lblHeader.text = data.1 + "\(data.3 == true ? "*":"")"
        checked = data.3 ?? false
        isRequired = data.3 ?? false
    }
    
    /*
    func setData(isChecked:Bool, header:String, selector:Selector, target:Any) {
        self.checked = isChecked
        self.lblHeader.text = header
        btnCheckBox.addTarget(target, action: selector, for: .touchUpInside)
        leadFormVC = target as? LeadCaptureFormViewController
    }
    */
    
    @IBAction func btnCheckBox(_ sender: Any) {
        checked = !checked
        //leadFormVC?.isContactPermission = checked
    }
    
}
