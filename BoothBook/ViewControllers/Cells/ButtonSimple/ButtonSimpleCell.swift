//
//  ButtonSimpleCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class ButtonSimpleCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title:String = "+ More Filters", selector:Selector, target:Any) {
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
    }
    
}
