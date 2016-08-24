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
    
    
    static func showViewWithAlpha(parentController: UIViewController,container:UIView,child:UIViewController)
    {
        
        child.view.frame = CGRectMake(0, 0, CGRectGetWidth(container.bounds), CGRectGetHeight(container.bounds))
        parentController.addChildViewController(child)
        child.view.alpha = 0
        container.addSubview(child.view)
        container.bringSubviewToFront(child.view)
        
        UIView.animateWithDuration(0.5) {
            child.view.alpha = 1
        }
        
    }
    
    static func showViewWithAlphaValue(container:UIView,child:UIViewController)
    {
        
        child.view.alpha = 0
        container.bringSubviewToFront(child.view)
        
        UIView.animateWithDuration(0.5) {
            child.view.alpha = 1
        }
        
    }
}