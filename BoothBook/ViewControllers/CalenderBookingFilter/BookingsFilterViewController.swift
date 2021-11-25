//
//  BookingsFilterViewController.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class BookingsFilterViewController: BaseViewController {
    
    @IBOutlet weak var tableView2: UITableView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView2Height: NSLayoutConstraint!
    
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var calenderViewAspectRatio: NSLayoutConstraint!
    var btnApplyFilter:UIButton!
    
    var textFieldData:[String] = Array(repeating: "", count: 6)
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing : 0])
    
    let listIcons = ["down", "calander","down","down","down","down"]
    let listPlaceHolder = ["Is greater than", "09/08/2019", "Booking ID #", "First Name", "Staff", "Last Name"]
    var displayFilterCells = 0
    var isLoading = true
    var queue:[Int] = [0,0,0]
    enum Moved:Int {
        case current = 0,
        next,
        prev
    }
    var numberOfCells: Int = 0 {
        didSet {
            if  numberOfCells > 40 {
                self.calenderViewAspectRatio?.constant = -60
            } else {
                self.calenderViewAspectRatio?.constant = 0
            }
        }
    }
    
    var moved:Moved = .current
    
    var bookingsList:[Booking] = [] {
        didSet{
            self.getBookingDatesCount()
            NotificationCenter.default.post(Notification(name: Notification.Name.BookingsListDidSet))
        }
    }
    
    let manager = BookingsManager()
    
    var bookingDates:[String:[Int]] = [:]
    var selectedBookings:[Booking] = []
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            guard let vcs = self.pageViewController.viewControllers else { return }
            guard vcs.count != 0 else { return }
            self.numberOfCells = (vcs[0] as? ViewController)?.thisMonth.dates.count ?? 0
        }
    }
    
    @objc func keyboardDidShow(){
        btnApplyFilter?.isEnabled = false
        btnApplyFilter?.backgroundColor = #colorLiteral(red: 0.8684565355, green: 0.8684565355, blue: 0.8684565355, alpha: 1)
    }
    
    @objc func keyboardDidHide(){
        btnApplyFilter?.isEnabled = true
        btnApplyFilter?.backgroundColor = #colorLiteral(red: 0.1221240982, green: 0.3086987734, blue: 0.5287244916, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addObserverKeyBoardShow(selector: #selector(keyboardDidShow))
        self.addObserverKeyBoardHide(selector: #selector(keyboardDidHide))
        bookingsList = Booking.current?.all() ?? []
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if UserDefaults.standard.bool(forKey: "isLoadedBookingAPI") == false {
                self.loadBookings()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    fileprivate func getBookingDatesCount() {
        let bookingDateList = self.bookingsList.map({ (booking) -> String in
            return Event(&booking[.event])[.event_date_iso].string ?? ""
        })  // Reading Event Dates
        self.bookingDates = [:] // For Event Dates Frequency Count
        for (index, date) in bookingDateList.enumerated() {
            if self.bookingDates[date] == nil {
                self.bookingDates[date] = []
            }
            self.bookingDates[date]!.append(index)
        }
        self.pageViewController.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView2Height.constant = 0
        //tableViewHeight.isActive = false
        self.isLogedin()
        setUpCalenderPageView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(UINib(nibName: "ButtonSimpleCell", bundle: .main), forCellReuseIdentifier: "ButtonSimpleCell")
        tableView2.register(UINib(nibName: "FilterTextViewCell", bundle: .main), forCellReuseIdentifier: "FilterTextViewCell")
        tableView2.register(UINib(nibName: "ButtonCell", bundle: .main), forCellReuseIdentifier: "ButtonCell")
        pageViewController.view.clipsToBounds = false
        //.backgroundImageView.clipsToBounds = YES;
        
        //tableView.register(UINib(nibName: "CalenderViewCell", bundle: .main), forCellReuseIdentifier: "CalenderViewCell")
        //tableView.register(UINib(nibName: "SubTableViewCell", bundle: .main), forCellReuseIdentifier: "SubTableViewCell")
        tableView.register(UINib(nibName: "BookingCell", bundle: .main), forCellReuseIdentifier: "BookingCell")
        
        customBarRightButton(imageName: "search2", selector: #selector(btnSearchPressed(_:)))
        
        loadBookings()
    }
    
    @IBAction func btnSearchPressed(_ sender: Any) {
        if displayFilterCells == 0 {
            displayFilterCells = 4
            tableView2Height?.constant = 60 * 5 + 50
        } else {
            displayFilterCells = 0
            tableView2Height?.constant = 0
        }
        
        tableView2.reloadData()
    }
    
}

extension BookingsFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView2 {
            return displayFilterCells + 2
        } else {
            return selectedBookings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView2 {
            if indexPath.row < displayFilterCells {
                let cell = UITableViewCell.getInstance(nibName: "FilterTextViewCell") as! FilterTextViewCell
                cell.setData(placeHolder: listPlaceHolder[indexPath.row], text: textFieldData[indexPath.row], iconName: listIcons[indexPath.row], tag:indexPath.row)
                cell.bookingFilterVC = self
                return cell
            } else if indexPath.row == displayFilterCells {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonSimpleCell") as! ButtonSimpleCell
                cell.configure(title: indexPath.row == 4 ? "+ More Filters":"- Less Filters", selector: #selector(moreFilters), target: self)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
                cell.configureButton("Apply", selector: #selector(applyFilter), target: self)
                btnApplyFilter = cell.button
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell") as! BookingCell
            cell.setData(selectedBookings[indexPath.row])
            return cell
        }
    }
    
    @objc func moreFilters(){
        print("Inside More Filters")
        if displayFilterCells == 4 {
            displayFilterCells = 6
            tableView2Height.constant = tableView2Height.constant + 120
        } else {
            displayFilterCells = 4
            tableView2Height.constant = tableView2Height.constant - 120
        }
        tableView2.reloadData()
    }
    
    @objc func applyFilter(){
        let isGratorThan = (tableView2.cellForRow(at: IndexPath(row: 0, section: 0)) as? FilterTextViewCell)?.pickerView.selectedRow(inComponent: 0) == 0
        
        
        //NSPredicate
        let bookings = bookingsList.filter { (booking) -> Bool in
            var isValid = true
            if let date = (tableView2.cellForRow(at: IndexPath(row: 1, section: 0)) as? FilterTextViewCell)?.textField.text?.toDate() {
                let evDate = (Event(&booking[.event])[.event_date_iso].string ?? "").toDate(DateFormat.event_date_iso) ?? Date()
                isValid = isGratorThan ? evDate > date:evDate < date
            }
            
            if isValid, let booking_id = (tableView2.cellForRow(at: IndexPath(row: 2, section: 0)) as? FilterTextViewCell)?.textField.text, booking_id != "" {
                let b_id = booking[.id].intValue
                isValid = b_id == (booking_id as NSString).integerValue
            }
            
            if isValid, let first_name = (tableView2.cellForRow(at: IndexPath(row: 3, section: 0)) as? FilterTextViewCell)?.textField.text, first_name != "" {
                isValid = (Customer(&booking[.customer])[.first_name].stringValue).contains(first_name) == true
            }
            
            
            if displayFilterCells == 6 {
                if isValid, let staff = (tableView2.cellForRow(at: IndexPath(row: 4, section: 0)) as? FilterTextViewCell)?.textField.text, staff != "" {
                    isValid = (Staff(&booking[.staff])[.written].stringValue).contains(staff)
                }
                
                if isValid, let last_name = (tableView2.cellForRow(at: IndexPath(row: 5, section: 0)) as? FilterTextViewCell)?.textField.text, last_name != ""{
                    isValid = (Customer(&booking[.customer])[.last_name].stringValue).contains(last_name)
                }
            }
            
            return isValid
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.btnSearchPressed(true)
        }
        let vc = SearchResultViewController(nibName: "SearchResultViewController", bundle: .main)
        vc.bookings = bookings
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension BookingsFilterViewController{
    fileprivate func setcurrentViewController() {
        let vc = ViewController(nibName: "ViewController", bundle: .main)
        vc.delegate = self
        vc.bookingVC = self
        vc.date = Date() //"2019 07 05".toDate("yyyy MM dd")!
        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func setUpCalenderPageView() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        setcurrentViewController()
        
        self.addChild(self.pageViewController)
        self.calenderView.addSubview(self.pageViewController.view)
        var pageViewRect = self.calenderView.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        }
        self.pageViewController.view.frame = pageViewRect
        self.pageViewController.didMove(toParent: self)
    }
    
    func display(contentController content: UIViewController, on view: UIView) {
        self.addChild(content)
        content.view.frame = view.bounds
        view.addSubview(content.view)
        content.didMove(toParent: self)
    }
}
extension BookingsFilterViewController:UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let vcs = pageViewController.viewControllers else { return }
        guard vcs.count != 0 else { return }
        numberOfCells = (vcs[0] as? ViewController)?.thisMonth.dates.count ?? 0
        //for vc in previousViewControllers {
        //    let date = (vc as! ViewController).date.components().month ?? 0
        //    print("For month: \(date)")
        //}
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        for vc in pendingViewControllers {
            let date = (vc as! ViewController).date.components().month ?? 0
            print("For month: \(date)")
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var date = (viewController as! ViewController).date
        date.setDay(dd: 10)
        let month = date.components().month!
        if month == 1 {
            date.setMonth(MM: 12)
            date.setYear(yyyy: date.components().year! - 1)
        } else {
            date.setMonth(MM: date.components().month! - 1)
        }
        let vc = ViewController(nibName: "ViewController", bundle: .main)
        //vc.setData(bookingsList: &self.bookingsList, bookingDates: &self.bookingDates)
        vc.delegate = self
        vc.bookingVC = self
        moved = .prev
        //print("movedNext: \(movedNext)")
        if date.components().month == Date().components().month {
            date.setDay(dd: Date().components().day!)
        }
        vc.date = date
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var date = (viewController as! ViewController).date
        date.setDay(dd: 10)
        let month = date.components().month
        if month == 12 {
            date.setMonth(MM: 1)
            date.setYear(yyyy: date.components().year! + 1)
        } else {
            date.setMonth(MM: date.components().month! + 1)
        }
        let vc = ViewController(nibName: "ViewController", bundle: .main)
        vc.delegate = self
        //vc.setData(bookingsList: &self.bookingsList, bookingDates: &self.bookingDates)
        vc.bookingVC = self
        moved = .next
        if date.components().month == Date().components().month {
            date.setDay(dd: Date().components().day!)
        }
        vc.date = date
        return vc
    }
    
    
}

extension BookingsFilterViewController:CalenderDelegate {
    func didSelectItemAt(viewController: ViewController, indexPath: IndexPath) {
        if let indexes = viewController.thisMonth.events[indexPath.row] {
            selectedBookings = indexes.map { (index) -> Booking in
                bookingsList[index]
            }
        } else {
            selectedBookings = []
        }
        self.tableView.reloadData()
    }
}

extension BookingsFilterViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView && selectedBookings.count > 0 {
            return 35
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = BookingsHeader()
        return hView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView2 { return }
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = BookingPageViewController(nibName: "BookingPageViewController", bundle: .main)
        vc.booking = selectedBookings[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BookingsFilterViewController {
    
    fileprivate func loadBookings() {
        // Load booking data
        self.progressHudShow(message: "loading...")
        //
        var sDate = Date()
        sDate.setDay()
        manager.bookings(scope: .full, startDate: sDate, endDate: nil) { (status, responseData) in
            if status.isSuccess {
                if let responseData = responseData {
                    let booking = Booking(responseData)
                    booking.save()
                    self.bookingsList = booking.all()
                }
                self.progressHudClose()
                self.loadPreviousBookings()
            } else {
                self.showAlert(message: status.message, btnTitle: "OK")
                self.progressHudClose()
            }
        }
    }
    
    fileprivate func loadPreviousBookings() {
        manager.bookings(scope: .full) { (status, responseData) in
            if status.isSuccess {
                if let responseData = responseData {
                    let booking = Booking(responseData)
                    booking.save()
                    self.bookingsList = booking.all()
                }
                self.progressHudClose()
                UserDefaults.standard.set(true, forKey: "isLoadedBookingAPI")
            } else {
                self.showAlert(message: status.message, btnTitle: "OK")
                self.progressHudClose()
            }
        }
    }
}
