//
//  UIImageExtension.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/23/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func scaleImage(){
        
        if sizeScale != 1{
            
            let size = self.image!.size.applying(CGAffineTransform(scaleX: sizeScale, y: sizeScale))
            let hasAlpha = true
            let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
            
            UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
            self.image!.draw(in: CGRect(origin: CGPoint.zero, size: size))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.image = scaledImage
            
        }
    }
}
