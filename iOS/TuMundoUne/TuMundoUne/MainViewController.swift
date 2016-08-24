//
//  MainViewController.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/22/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    
    var cameraPermission:CameraPermissionViewController!
    var cameraControl:CameraControlViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.settings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func settings(){
    
        if self.cameraStatus(){
            print("Ready To Go")
            self.showCameraControlView()
        }
    }
    
    
    //***********************************************//
    //*************** Camera Methods ****************//
    //***********************************************//
    
    func cameraStatus()->Bool{
        
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.Denied
        {
            // Already Authorized
            self.showCameraPermissionView()
            return false
        }else if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) ==  AVAuthorizationStatus.NotDetermined{
            
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (result) in
                
                self.settings()
            }
            return false
        
        }else{
            
            return true
        }
        
    }
    
    func showCameraPermissionView(){
        
        if cameraPermission == nil{
            
            cameraPermission = UIStoryboard(name: Constants.STORYBOARD_IPHONE, bundle: nil).instantiateViewControllerWithIdentifier("Camera Permission") as! CameraPermissionViewController
            //posts.potsDelegate = self
            UIAnimationsViews.showViewWithAlpha(self, container: self.view, child: cameraPermission)
        }else{
            UIAnimationsViews.showViewWithAlphaValue(self.view, child: cameraPermission)
        }
        //cameraPermission.settings()
        
        
    }
    
    func showCameraControlView(){
        
        if cameraControl == nil{
            
            cameraControl = UIStoryboard(name: Constants.STORYBOARD_IPHONE, bundle: nil).instantiateViewControllerWithIdentifier("Camera Control") as! CameraControlViewController
            //posts.potsDelegate = self
            UIAnimationsViews.showViewWithAlpha(self, container: self.view, child: cameraControl)
        }else{
            UIAnimationsViews.showViewWithAlphaValue(self.view, child: cameraControl)
        }
        //cameraPermission.settings()
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
