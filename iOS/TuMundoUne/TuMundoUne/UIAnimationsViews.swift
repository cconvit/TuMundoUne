//
//  UIAnimationsViews.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/22/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import Foundation
import UIKit

class UIAnimationsViews: NSObject {
    
    
    static func showViewWithAlpha(_ parentController: UIViewController,container:UIView,child:UIViewController)
    {
        
        child.view.frame = CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height)
        parentController.addChildViewController(child)
        child.view.alpha = 0
        container.addSubview(child.view)
        //container.bringSubview(toFront: child.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            child.view.alpha = 1
        }) 
        
    }
    
    static func showViewWithAlphaValue(_ container:UIView,child:UIViewController)
    {
        
        child.view.alpha = 0
        container.bringSubview(toFront: child.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            child.view.alpha = 1
        }) 
        
    }
}
