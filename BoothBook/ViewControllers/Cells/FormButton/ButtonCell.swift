//
//  ButtonCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureButton (_ title:String, selector:Selector, target:Any, bgColor:UIColor = #colorLiteral(red: 0.1221240982, green: 0.3086987734, blue: 0.5287244916, alpha: 1)){
        button.backgroundColor = bgColor
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
    }
    
}
