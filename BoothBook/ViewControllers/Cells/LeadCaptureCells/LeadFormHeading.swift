//
//  LeadFormHeading.swift
//  BoothBook
//
//  Created by abbas on 04/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class LeadFormHeading: UITableViewCell {
    
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(image:UIImage?){
        if let image = image {
            logoImage.image = image
            nameLabel.isHidden = true
            logoImage.isHidden = false
        } else {
            logoImage.isHidden = true
            nameLabel.isHidden = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
