//
//  CommonUtils.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/23/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import Foundation

struct CommonUtils {
    static func imageWithImage(image: UIImage, scaleToSize newSize: CGSize, isAspectRation aspect: Bool) -> UIImage{
        
        let originRatio = image.size.width / image.size.height;//CGFloat
        let newRatio = newSize.width / newSize.height;
        
        var sz: CGSize = CGSizeZero
        
        if (!aspect) {
            sz = newSize
        }else {
            if (originRatio < newRatio) {
                sz.height = newSize.height
                sz.width = newSize.height * originRatio
            }else {
                sz.width = newSize.width
                sz.height = newSize.width / originRatio
            }
        }
        let scale: CGFloat = 1.0
        
        sz.width /= scale
        sz.height /= scale
        UIGraphicsBeginImageContextWithOptions(sz, false, scale)
        image.drawInRect(CGRectMake(0, 0, sz.width, sz.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}