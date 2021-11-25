//
//  BookingsHeader.swift
//  BoothBook
//
//  Created by abbas on 04/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class BookingsHeader: UIView {

    @IBOutlet weak var title: UILabel!
    var isForLeadForm = false
    //@IBOutlet var contentView: UIView!
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }
    
    func setupTableView(){
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
        view.layoutIfNeeded()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
// Utality Method
extension BookingsHeader {
    func setData(title:String, isForLeadForm:Bool = false) {
        if !isForLeadForm {
            view.addShadow(height: -1.0, shadowColor: #colorLiteral(red: 0.6074417203, green: 0.6134559948, blue: 0.6134559948, alpha: 1))
        } else {
            self.backgroundColor = .white
        }
        self.title.text = title
    }
}
