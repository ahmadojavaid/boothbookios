//
//  CalenderViewCell.swift
//  BoothBook
//
//  Created by abbas on 25/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class CalenderViewCell: UITableViewCell {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing : 0])
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        let vc = ViewController(nibName: "ViewController", bundle: .main) 
        vc.date = Date()
        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        
        //self.addChild(self.pageViewController)
        //self.view.addSubview(self.pageViewController.view)
        if let vew = pageViewController.viewIfLoaded {
            vew.frame = self.frame
            vew.bounds = self.bounds
            self.addSubview(vew)
        }
        //self.addSubview(pageViewController.view)

        //var pageViewRect = self.view.bounds
        //if UIDevice.current.userInterfaceIdiom == .pad {
        //   pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
        //}
        //self.pageViewController.view.frame = pageViewRect
        
        //self.pageViewController.didMove(toParent: self)
    }
}

extension CalenderViewCell:UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
        if date.components().month == Date().components().month {
            date.setDay(dd: Date().components().day!)
        }
        vc.date = date
        return vc
    }
}
