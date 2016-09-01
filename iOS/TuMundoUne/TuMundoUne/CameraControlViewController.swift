//
//  CameraControlViewController.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/22/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import UIKit
import ReplayKit

protocol CameraButtonControllersDelegate {
    func videoActionDelegate(button:UIButton)
    func photoActionDelegate(button:UIButton)
}

class CameraControlViewController: UIViewController,RPScreenRecorderDelegate,RPPreviewViewControllerDelegate,CameraButtonControllersDelegate {

    
    @IBOutlet weak var vuforiaContainerUIView: UIView!
    
    
    
    var buttonWindow: UIWindow!
    let recorder = RPScreenRecorder.sharedRecorder()
    var vuforiaView:ViewController!
    var isRecording:Bool = false
    //let vuforiaContainerPositionY:[CGFloat] = [98,116,265,368]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.settings()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        
        
        self.addButtonsControllers()
        UIAnimationsViews.showViewWithAlpha(self, container: self.view, child: vuforiaView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //***********************************************//
    //***************** UI Methods ******************//
    //***********************************************//
    
    func isRecorderAvailable(controllers:CamaraButtonsControlViewController){
        
        guard recorder.available else{
            controllers.videoButtonHide = true
            controllers.photoButtonPositionX  = UIScreen.mainScreen().bounds.size.width/2
            return
        }
        

    }
    
    func settings(){
    
        self.showVuforiaView()
        
    }
    

    func showVuforiaView(){
        
        vuforiaView = UIStoryboard(name: Constants.STORYBOARD_IPHONE, bundle: nil).instantiateViewControllerWithIdentifier("Vuforia") as! ViewController
    }
    
    func startAnimationRecordingVideo(sender:UIButton){
    
        
        UIView.animateWithDuration(0.5, delay:0, options: [.Repeat, .Autoreverse], animations: {
            
            sender.alpha = 0.5
            
            
            }, completion: nil)
        
        
        
        
    }
    
    func stopAnimationRecordingVideo(){
        
        
    }
    
    //***********************************************//
    //*************** Buttons Methods ***************//
    //***********************************************//
    
    func videoActionDelegate(sender: UIButton) {
        
        if self.isRecording{
            self.stopVideoRecording(sender)
        }else{
           // self.startAnimationRecordingVideo(sender)
            self.starVideoRecording(sender)
        }
    }
    
    func photoActionDelegate(sender: UIButton) {
        
        let old = sender.transform
        
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: {
            
            sender.transform=CGAffineTransformMakeScale(1.5, 1.5)
            sender.alpha = 0.5
            }, completion: { (result) in
                
                UIView.animateWithDuration(0.3, animations: {
                    sender.transform=old
                    sender.alpha = 1
                })
        })

        
        UIImageWriteToSavedPhotosAlbum(self.view.pb_takeSnapshot(), nil, nil, nil)
    }
    
    //***********************************************//
    //**************** Util Methods *****************//
    //***********************************************//
    
    func changeVideoIconButton(button:UIButton){
    
        var image:UIImage!
        if self.isRecording{
            
            image = UIImage(named: "IconVideo")
            
        }else{
            image = UIImage(named: "IconVideoRecord")
        }
        
        button.setImage(image, forState: UIControlState.Normal)
        self.isRecording = !self.isRecording
    
    }
    
    func deInitVuforiaView(){
    
        self.vuforiaView.removeFromParentViewController()
        self.vuforiaView.view.removeFromSuperview()
        self.vuforiaView = nil
    }
    
    //***********************************************//
    //*************** Record Methods ****************//
    //***********************************************//
    
    func addButtonsControllers() {
        
        self.buttonWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        let cameraButtonsControllers = UIStoryboard(name: Constants.STORYBOARD_IPHONE, bundle: nil).instantiateViewControllerWithIdentifier("Camara Buttons Control") as! CamaraButtonsControlViewController
        cameraButtonsControllers.delegate = self
        self.isRecorderAvailable(cameraButtonsControllers)
        self.buttonWindow.rootViewController = cameraButtonsControllers
        self.buttonWindow.makeKeyAndVisible()
        
    }
    
    func starVideoRecording(button:UIButton){
    
        dispatch_async(dispatch_get_main_queue(),{
            
            guard self.recorder.available else{
                print("Cannot record the screen")
                return
            }
            
            self.recorder.delegate = self
            
            self.recorder.startRecordingWithMicrophoneEnabled(true){err in
                guard err == nil else {
                    if err!.code == RPRecordingErrorCode.UserDeclined.rawValue{
                        print("User declined app recording")
                    }
                    else if err!.code == RPRecordingErrorCode.InsufficientStorage.rawValue{
                        print("Not enough storage to start recording")
                    }
                    else {
                        print("Error happened = \(err!)")
                    }
                    return
                }
                
                print("Successfully started recording")
                self.changeVideoIconButton(button)
            }
            
        })
        
        
        

    }
    
    func stopVideoRecording(button:UIButton) {
        
      //  self.deInitVuforiaView()
        dispatch_async(dispatch_get_main_queue(),{
            
            self.recorder.stopRecordingWithHandler{controller, err in
                
                guard let previewController = controller where err == nil else {
                    print("Failed to stop recording")
                    return
                }
                
                self.changeVideoIconButton(button)
                self.buttonWindow.rootViewController!.view.hidden = true
                previewController.previewControllerDelegate = self
                
                self.presentViewController(previewController, animated: true,
                    completion: nil)
                
            }
            
        })
        
        
        
        
    }

    
    //***********************************************//
    //******* Record Preview Delegate Methods *******//
    //***********************************************//
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
        print("Finished the preview")
        self.buttonWindow.rootViewController!.view.hidden = false
        dismissViewControllerAnimated(true, completion: nil)
        
        //self.showVuforiaView()
    }
    
    func previewController(previewController: RPPreviewViewController,didFinishWithActivityTypes activityTypes: Set<String>) {
        print("Preview finished activities \(activityTypes)")
    }
    
    //***********************************************//
    //*********** Record Delegate Methods ***********//
    //***********************************************//
    
    
    func screenRecorderDidChangeAvailability(screenRecorder: RPScreenRecorder) {
        print("Screen recording availability changed")
    }
    
    func screenRecorder(screenRecorder: RPScreenRecorder,
                        didStopRecordingWithError error: NSError,
                                                  previewViewController: RPPreviewViewController?) {
        print("Screen recording finished")
    }

    
    

}
