//
//  HeaderView.swift
//  RxRun
//
//  Created by abbas on 28/08/2019.
//  Copyright © 2019 Amad Khilji. All rights reserved.
//

import UIKit

class EditLeadsHeaderView: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lblDisplay: UILabel!
    @IBOutlet weak var lblRequired: UILabel!
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
extension EditLeadsHeaderView {
    func setData(title:String, hide_D_R:Bool = false) {
        self.title.text = title
        self.lblDisplay.isHidden = hide_D_R
        self.lblRequired.isHidden = hide_D_R
    }
}
