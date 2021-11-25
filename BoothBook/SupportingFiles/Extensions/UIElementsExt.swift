//
//  UIElementsExt.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import UIKit

extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}


extension UIFont {
    
    static func OpenSans(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func OpenSansBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func OpenSansBoldItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-BoldItalic", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func OpenSansSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func OpenSansLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func OpenSansExtraBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-ExtraBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func OpenSansItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Italic", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UITableView {
    
    func addRefreshControl(_ target: Any, selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: selector, for: .valueChanged)
        refreshControl.backgroundColor = UIColor.clear
        self.refreshControl = refreshControl
    }
}

extension UITableViewCell {
    static func getInstance(nibName:String) -> UITableViewCell? {
        if let nibContents = Bundle.main.loadNibNamed(nibName, owner: UITableViewCell(), options: nil) {
            for item in nibContents {
                if let cell = item as? UITableViewCell {
                    return cell
                }
            }
        }
        return nil
    }
}
/*
extension UICollectionViewCell {
    static func getInstance(nibName:String) -> UICollectionViewCell? {
        if let nibContents = Bundle.main.loadNibNamed(nibName, owner: UICollectionViewCell(), options: nil) {
            for item in nibContents {
                if let cell = item as? UICollectionViewCell {
                    return cell
                }
            }
        }
        return nil
    }
}
*/

extension Array where Element: UIView {
    func index(of view: UIView) -> Int? {
        for (index, value) in self.enumerated() {
            if value == view {
                return index
            }
        }
        return nil
    }
}
