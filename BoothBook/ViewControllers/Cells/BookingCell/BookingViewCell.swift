//
//  BookingViewCell.swift
//  BoothBook
//
//  Created by abbas on 22/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class BookingViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var llbTextDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setDataBold(_ imageName:String, _ detal:String) {
        iconImage.image = UIImage(named: imageName)
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        //attributes[.foregroundColor] = UIColor.white
        attributes[.font] = UIFont.OpenSansBold(ofSize: 14)

        let atrSt = NSAttributedString(string: detal, attributes: attributes)
        
        llbTextDetail.attributedText = atrSt
    }
    
    func setDataRegular(_ imageName:String, _ detal:String) {
        iconImage.image = UIImage(named: imageName)
        
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.foregroundColor] = #colorLiteral(red: 0.1214775765, green: 0.2572132857, blue: 0.4186286031, alpha: 1)
        attributes[.font] = UIFont.OpenSansLight(ofSize: 14)
        
        let atrSt = NSAttributedString(string: detal, attributes: attributes)
        
        llbTextDetail.attributedText = atrSt
    }
    func setName(_ imageName:String, _ detal:[String]) {
        iconImage.image = UIImage(named: imageName)
        
        let text = "\(detal[0]) \(detal[1]) \(detal[2])"
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont.OpenSansLight(ofSize: 14)
        
        let atrSt = NSMutableAttributedString(string: text, attributes: attributes)
        atrSt.addAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3334589569, green: 0.7351181256, blue: 0.6729057488, alpha: 1) ], range: NSRange(location: detal[0].count + 1, length: detal[1].count))
        
        llbTextDetail.attributedText = atrSt
    }
    
    func setDataLightRegular(_ imageName:String, _ detal1:String, detal2:String) {
        iconImage.image = UIImage(named: imageName)
        let text = detal1 + "\n" + detal2
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont.OpenSans(ofSize: 14)
        
        let atrSt = NSMutableAttributedString(string: text, attributes: attributes)
        atrSt.addAttributes([NSAttributedString.Key.font : UIFont.OpenSansLight(ofSize: 14)], range: NSRange(location: 0, length: detal1.count))
        llbTextDetail.attributedText = atrSt
    }
    
    func setDataLight(_ imageName:String, _ detal:String) {
        iconImage.image = UIImage(named: imageName)
        var attributes = [NSAttributedString.Key: AnyObject]()
        attributes[.font] = UIFont.OpenSansLight(ofSize: 14.0)
        let atrSt = NSAttributedString(string: detal, attributes: attributes)
        llbTextDetail.attributedText = atrSt
    }
    
    /*
    func setData(_ imageName:String,_ detail:String, _ color: UIColor = UIColor.darkText, _ weight: FontWeight = .regular, size:CGFloat = 16.0){
        iconImage.image = UIImage(named: imageName)
        llbTextDetail.text = detail
        llbTextDetail.textColor = color
        llbTextDetail.font = UIFont(name: weight.rawValue, size: size)
    }
 */
    
}
