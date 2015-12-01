//
//  DealDetailsConstants.swift
//  Groupon UP
//
//  Created by Ping Zhang on 11/21/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Foundation
import UIKit

let screenSize = UIScreen.mainScreen().bounds

struct UPDealDetailsBase {
    static let imageHeight = 0.6 * screenSize.width
    static let dealInfoHeight = imageHeight * 0.35
    
    static let offset = 0
    static let titleOffset = 8
    static let subOffset = 4
    
    static let bottomButtonHeight = 40
    static let expiredAtFont = UIFont(name: "Avenir", size: 14)
    static let expiredAtFontColor = UIColor.grayColor()
    
    static let titleFont = UIFont(name: "Avenir-Heavy", size: 15)
}

struct UPDeal {
    static let imageHeight = 0.6 * screenSize.width
    static let dealInfoHeight = imageHeight * 0.5
    static let titleHeight = 0.5 * dealInfoHeight
    static let divisionHeight = 15
    static let valueHeight = divisionHeight
    static let priceHeight = 20
    
    static let offset = 0
    static let titleOffset = 8
    static let subOffset = 4
    static let bottomInfoOffset = 8
    
    static let titleFont = UIFont(name: "Avenir-Heavy", size: 15)
    static let otherFont = UIFont(name: "Avenir", size: 14)
    static let otherFontColor = UIColor.lightGrayColor()
    
    static let priceFont = UIFont(name: "Avenir-Heavy", size: 16)
    static let priceFontColor = UIColor(hue:0.25, saturation:1, brightness:0.7, alpha:1)
    
    static let backgroundColor = UIColor.whiteColor()
}