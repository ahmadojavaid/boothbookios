//
//  Array.swift
//  BoothBook
//
//  Created by abbas on 03/12/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//
/*
import Foundation
protocol Content {
    var hash: String { get }
}
extension Array where Element : Content {
    //let originalArray = ["hotdog","fries","hotdog","coke","coke","fries","hotdog"]
    //var dict = [String: Int]()
    /*
     let resultString = originalArray.reduce(dict) { _, element in
     if dict[element] == nil {
     dict[element] = 1
     } else {
     dict[element]! += 1
     }
     return dict
     }
     .map { "\($0) x \($1)" }
     .joinWithSeparator(", ")
     */
    
    func catagorize()->[String:[Element]] {
        var dict = [String: Element]()
        self.reduce(into: dict) { (<#inout Result#>, <#Content#>) in
            <#code#>
        }
        let resultString = self.reduce(dict) { _, element in
            if dict[element] == nil {
                dict[element] = 1
            } else {
                dict[element]! += 1
            }
            return dict
            }
            .map { "\($0) x \($1)" }
            .joinWithSeparator(", ")
    }
}

*/
