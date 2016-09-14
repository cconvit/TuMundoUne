//
//  HiddenStatusBarViewController.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/22/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import UIKit

class CamaraButtonsControlViewController: UIViewController {

    @IBOutlet weak var topBanerImageUIImageView: UIImageView!
    @IBOutlet weak var videoUIButton: UIButton!
    @IBOutlet weak var cameraUIButton: UIButton!
    
    @IBOutlet weak var topBanerHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBanerAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonsWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    var delegate:CameraButtonControllersDelegate!
    var videoButtonHide:Bool = false
    var photoButtonPositionX:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateConstraint()
        self.setCustomView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateConstraint(){
    
        self.videoButtonRightConstraint.constant = self.videoButtonRightConstraint.constant * sizeScale
        self.videoButtonRightConstraint.constant = self.videoButtonRightConstraint.constant * sizeScale
        self.photoButtonLeftConstraint.constant = self.photoButtonLeftConstraint.constant * sizeScale
        self.buttonBottomConstraint.constant = self.buttonBottomConstraint.constant * sizeScale

    }
    
    func setCustomView(){
        
        if self.videoButtonHide{
        
            self.videoUIButton.isHidden = self.videoButtonHide
            let xConstraint = NSLayoutConstraint(item: self.cameraUIButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            
            self.view.addConstraint(xConstraint)
        }
        
        if device_type != 0 && device_type != 1 && device_type != 2 && device_type != 3  {
            
            self.topBanerImageUIImageView.image = UIImage(named: "TopBanerIpad")

        }else{
            self.topBanerHightConstraint.constant = self.topBanerHightConstraint.constant * sizeScale
        }
        
        if device_type == 0 || device_type == 1 || device_type == 2{
        
            self.bottomButtonsHeightConstraint.constant = self.bottomButtonsHeightConstraint.constant * sizeScale
            self.bottomButtonsWidthConstraint.constant = self.bottomButtonsWidthConstraint.constant * sizeScale
        }
        
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    @IBAction func videoAction(_ sender: UIButton) {
        
        self.delegate.videoActionDelegate(sender)
    }
    
    @IBAction func photoAction(_ sender: UIButton) {
        
        self.delegate.photoActionDelegate(sender)
    }
    
    //***********************************************//
    //*************** Gesture Methods ***************//
    //***********************************************//
    
    @IBAction func tapTopBanner(_ sender: UITapGestureRecognizer) {
        
        let url = URL(string: Constants.URL_UNE)!
        UIApplication.shared.openURL(url)
    }


}
