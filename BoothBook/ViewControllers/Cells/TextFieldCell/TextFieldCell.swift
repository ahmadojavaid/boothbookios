//
//  TextFieldCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var lblTextFieldHeader: UILabel!
    
    @IBOutlet weak var txtFieldContent: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtFieldContent.frame.size.height))
        txtFieldContent.leftView = paddingView
        txtFieldContent.leftViewMode = .always
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(header:String, placeHolder:String) {
        lblTextFieldHeader.text = header
        txtFieldContent.placeholder = placeHolder
    }
    
}
