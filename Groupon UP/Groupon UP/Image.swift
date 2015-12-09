//
//  Image.swift
//  Groupon UP
//
//  Created by Ping Zhang on 12/8/15.
//  Copyright © 2015 Chang Liu. All rights reserved.
//

import Foundation
import UIKit

class ImageUtility {
    static func reSizeUIImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}