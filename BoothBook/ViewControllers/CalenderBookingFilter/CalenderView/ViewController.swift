//
//  ViewController.swift
//  CalenderTest
//
//  Created by abbas on 27/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit
protocol CalenderDelegate:class {
    func didSelectItemAt( viewController: ViewController, indexPath:IndexPath)
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:CalenderDelegate?
    weak var bookingVC:BookingsFilterViewController?
    var date = Date()
    var thisMonth = Month()
    
    //var bookingsList: [Booking] = []
    //var bookingDates: [String:[Int]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //date.setMonth(MM: 6)
        thisMonth = monthComps(thisDate: date)
        lblMonth.text = "\(date.toString("MMMM yyyy"))".uppercased()
        
        collectionView.register(UINib(nibName: "DateCell", bundle: .main), forCellWithReuseIdentifier: "dateCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(bookingsListDidSet), name: NSNotification.Name.BookingsListDidSet, object: nil)
    }
    
    @objc func bookingsListDidSet(){
        DispatchQueue.main.async {
            self.thisMonth = self.monthComps(thisDate: self.date)
            self.collectionView.reloadData()
        }
    }
    //func setData(bookingsList:inout [Booking], bookingDates:inout [String:[Int]]) {
    //    self.bookingDates = bookingDates
    //    self.bookingsList = bookingsList
    //    print("bookingDates:\(bookingDates.count) bookingsList:\(bookingsList.count)")
    //}
    
    //override func viewWillAppear(_ animated: Bool) {
    //    super.viewWillAppear(animated)
    //    layoutCollectionView()
    //}
    override func viewWillLayoutSubviews() {
        layoutCollectionView()
    }
    struct Month {
        var year: Int = 2000
        var month: Int = 1
        var days: Int = 31
        var firstDay: Int = 1
        var dates:[Int] = []
        var events:[Int:[Int]] = [:]
        var currentDateIndex:Int?
    }
    func monthComps(thisDate:Date) -> Month{
        var roundThisDate = Date()
        roundThisDate.setDay(dd: 1)
        var month = Month()
        month.year = thisDate.components().year!
        month.month = thisDate.components().month!
        month.days = Date.monthDays(month.month)
        let prevMonthDays = Date.monthDays((month.month == 1) ? 12:(month.month-1))
        var rounDate = thisDate
        rounDate.setDay(dd: 1)
        month.firstDay = Calendar(identifier: Calendar.Identifier.gregorian).component(.weekday, from: rounDate)
        let noCells = Int(ceil(Double(Date.monthDays(month.month) + month.firstDay - 1)/7.0)*7)
        if month.firstDay > 1 {
            month.dates = ((prevMonthDays - month.firstDay + 2) ... prevMonthDays).map { return $0 }
        }
        month.dates = month.dates + (1 ... month.days).map{return $0}
        // calculation for events
        for (index, dt) in month.dates.enumerated() {
            if index > month.firstDay - 2 {
                let ifDate = self.date.toString("yyyy-MM") + (dt < 10 ? "-0\(dt)":"-\(dt)")
                if let dIndex = bookingVC?.bookingDates[ifDate] {
                    month.events[index] = dIndex
                }
            }
        }
        // End events calculations
        if month.dates.count < noCells {
            month.dates = month.dates + (1 ... (noCells - month.dates.count)).map{return $0}
        }
        
        if roundThisDate.toString().toDate() == rounDate.toString().toDate() {
            let day = thisDate.components().day!
            month.currentDateIndex = month.firstDay - 2 + day
        }
        return month
    }
    fileprivate func layoutCollectionView() {
        let viewWidth = view.frame.size.width
        let edgeInset:CGFloat =  3.0
        //let viewWidth = (self.view.bounds.size.width - (40.0 * widthRation))/3.0
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (viewWidth - 68)/7, height: (viewWidth - 68)/8)
        layout.minimumInteritemSpacing = 1  // Vertical Spacing
        layout.minimumLineSpacing = 3      // Horizantal Spacing
        //layout.headerReferenceSize = CGSize(width: 0, height: 35)
        layout.sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        collectionView.collectionViewLayout = layout
    }
}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thisMonth.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = DateCell.getInstance(nibName: "DateCell") as! DateCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = "\(thisMonth.dates[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cll = cell as! DateCell
        if indexPath.row < (thisMonth.firstDay - 1) {
            selectCell(type: .notThisMonth, cell: cll)
        } else if indexPath.row < (thisMonth.days + thisMonth.firstDay - 1) {
            if thisMonth.currentDateIndex ?? -1 == indexPath.row {
                selectCell(type: .current, cell: cll)
            } else if thisMonth.events[indexPath.row]?.count ?? 0 > 0 {
                selectCell(type: .withEvent, cell: cll)
            } else {
                selectCell(type: .thisMonth, cell: cll)
            }
            
        } else {
            selectCell(type: .notThisMonth, cell: cll)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItemAt(viewController: self, indexPath: indexPath)
        if indexPath.row < (thisMonth.days + thisMonth.firstDay - 1) {
            let cell = collectionView.cellForItem(at: indexPath) as! DateCell
            selectCell(type: .selected, cell: cell)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row < (thisMonth.days + thisMonth.firstDay - 1) {
            let cell = collectionView.cellForItem(at: indexPath) as! DateCell
            selectCell(type: .unselected, cell: cell)
        }
    }
    
    enum cellType:Int {
        case thisMonth = 0,
        withEvent,
        current,
        notThisMonth,
        selected,
        unselected
    }
    func selectCell( type:cellType, cell:DateCell){
        switch type {
        case .thisMonth:
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
            cell.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .withEvent:
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.dateLabel.textColor = #colorLiteral(red: 0.1984137893, green: 0.3879907429, blue: 0.5914616585, alpha: 1)
        case .current:
            cell.backgroundColor = UIColor(red: 0.2265487909, green: 0.4117030799, blue: 0.6110457778, alpha: 0.2)
            cell.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //cell.dateLabel.layer.borderColor = #colorLiteral(red: 0.1266943867, green: 0.3057980273, blue: 0.5138404188, alpha: 1)
            //cell.dateLabel.layer.borderWidth = 1
        case .notThisMonth:
            cell.backgroundColor = .clear
            cell.dateLabel.textColor = #colorLiteral(red: 0.1141350046, green: 0.2119239469, blue: 0.323723033, alpha: 1)
        case .selected:
            cell.layer.borderColor = #colorLiteral(red: 0.09831780424, green: 0.2365999173, blue: 0.3905403082, alpha: 1)
            cell.layer.borderWidth = 1
        case .unselected:
            cell.layer.borderWidth = 0
        }
    }
}


