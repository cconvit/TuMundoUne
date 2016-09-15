//
//  UIImageExtension.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 9/14/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import Foundation

extension UIImage {
    
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint(x:0,y:0), blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
