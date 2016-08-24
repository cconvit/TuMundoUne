//
//  TutorialViewController.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/22/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    
    @IBOutlet weak var logoUneImageUIImageView: UIImageView!
    @IBOutlet weak var instruccionesImageUIImageView: UIImageView!
    @IBOutlet weak var tutorialImageUIImageView: UIImageView!
    @IBOutlet weak var dotsImageUIImageView: UIImageView!
    
    @IBOutlet weak var logoUneImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var instruccionesImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorialImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotsImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotsImageBottomConstraint: NSLayoutConstraint!
    
    let tutorialImages = ["Tutorial1","Tutorial2","Tutorial3"]
    let dotImages = ["Dots1","Dots2","Dots3"]
    var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setCustomView()
        self.updateConstraint()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCustomView(){
    
        self.setImageAtIndex(self.currentIndex)
    }
    
    func updateConstraint(){
    
        if device_type != 0 && device_type != 1 && device_type != 2 && device_type != 3  {
            
            self.view.removeConstraint(self.dotsImageBottomConstraint)
        }else{
            self.dotsImageBottomConstraint.constant = self.dotsImageBottomConstraint.constant * sizeScale
        }
        
        self.logoUneImageTopConstraint.constant = self.logoUneImageTopConstraint.constant * sizeScale
        self.instruccionesImageTopConstraint.constant = self.instruccionesImageTopConstraint.constant * sizeScale
        self.tutorialImageTopConstraint.constant = self.tutorialImageTopConstraint.constant * sizeScale
        self.dotsImageTopConstraint.constant = self.dotsImageTopConstraint.constant * sizeScale
        
        
    }
    
    
    //***********************************************//
    //*************** Gesture Methods ***************//
    //***********************************************//
    
    
    @IBAction func rightAction(sender: UISwipeGestureRecognizer) {
        
        if self.currentIndex-1 >= 0{
            
            self.currentIndex -= 1
            self.setImageAtIndex(self.currentIndex)
        }
        
    }
    
    
    @IBAction func leftAction(sender: UISwipeGestureRecognizer) {
        
        if self.currentIndex+1 < self.tutorialImages.count{
        
            self.currentIndex += 1
            self.setImageAtIndex(self.currentIndex)
        }else if self.currentIndex+1 == self.tutorialImages.count{
            self.performSegueWithIdentifier("GoToMain", sender: self)
        }
        
        
    }
    
    //***********************************************//
    //***************** Util Methods ****************//
    //***********************************************//
    
    func setImageAtIndex(index:Int){
        
  
        UIView.transitionWithView(self.tutorialImageUIImageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.tutorialImageUIImageView.image = UIImage(named: self.tutorialImages[index])
            }) { (result) in
                
        }
        
        
        
        self.dotsImageUIImageView.image = UIImage(named: self.dotImages[index])
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
