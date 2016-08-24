//
//  Devices.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/23/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import Foundation

var device_type:Int=0
var device_UI:Int=0
var sizeScale: CGFloat=1
class Devices{
    
    
    let iPhone4     = 0
    let iPhone5     = 1
    let iPhone6     = 2
    let iPhone6Plus = 3
    let iPad2       = 4
    let iPadRetina  = 4
    
    func dev_width()  -> CGFloat { return UIScreen.mainScreen().bounds.size.width  }
    
    func dev_height() -> CGFloat { return UIScreen.mainScreen().bounds.size.height }
    
    func dev_scale()  -> CGFloat { return UIScreen.mainScreen().scale }
    
    func is_IPAD() -> Bool {
        if (device_type==iPad2) || (device_type==iPadRetina) {
            return true
        }
        return false
    }
    
    func get_device_id()  {
        switch dev_width() {
            
            case 320: // either a 4s or 5s
                device_type=iPhone4
                sizeScale=0.65217391
                if dev_height()>480 {
                    
                    device_type=iPhone5
                    sizeScale=0.77173913
                }
            case 375:
                device_type=iPhone6
                sizeScale=0.90748299
            case 414:
                device_type=iPhone6Plus
                sizeScale=1
            case 768: // either iPad2 or Retina
                device_type=iPad2
                sizeScale=2
                if dev_scale()==2 {
                    device_type=iPadRetina
                }
            default:
                device_type=iPad2
                sizeScale=2
        }
        
        print(dev_width())
    }

    
}