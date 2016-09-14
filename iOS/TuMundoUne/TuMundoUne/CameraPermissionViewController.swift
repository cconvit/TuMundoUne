//
//  CameraPermissionViewController.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/22/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import UIKit

class CameraPermissionViewController: UIViewController {

    
    @IBOutlet weak var permitirUIButton: UIButton!
    
    @IBOutlet weak var cameraLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var permiteLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var permitirButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var permitirButtonBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateConstraint()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateConstraint(){
    
        
        self.permiteLabelTopConstraint.constant = self.permiteLabelTopConstraint.constant * sizeScale
        self.permitirButtonTopConstraint.constant = self.permitirButtonTopConstraint.constant * sizeScale
        
        if device_type != 0 && device_type != 1 && device_type != 2 && device_type != 3  {
            
            self.view.removeConstraint(self.permitirButtonBottomConstraint)
        }else{
             self.cameraLogoTopConstraint.constant = self.cameraLogoTopConstraint.constant * sizeScale
            self.permitirButtonBottomConstraint.constant = self.permitirButtonBottomConstraint.constant * sizeScale
        }
    }
    //***********************************************//
    //*************** Buttons Methods ***************//
    //***********************************************//
    
    
    @IBAction func requestCameraPermissionAction(_ sender: AnyObject) {
        
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(url)
        }
        
    }

    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}
