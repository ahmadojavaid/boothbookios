//
//  EditLeadDesignCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class EditLeadDesignCell: UITableViewCell {

    @IBOutlet weak var lblFildName: UILabel!
    @IBOutlet weak var pickerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(title:String, buttonTitle:String, selector:Selector, target:Any, tag:Int){
        lblFildName.text = title
        pickerButton.addTarget(target, action: selector, for: .touchUpInside)
        pickerButton.setTitle(" " + buttonTitle, for: .normal)
        pickerButton.tag = tag
        self.tag = tag
    }
    
}
