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
    func videoActionDelegate(_ button:UIButton)
    func photoActionDelegate(_ button:UIButton)
}

protocol MaskViewDelegate {
    func pinguinosMask()
    func futbolistaMask()
}

class CameraControlViewController: UIViewController,RPScreenRecorderDelegate,RPPreviewViewControllerDelegate,CameraButtonControllersDelegate,MaskViewDelegate{

    
    @IBOutlet weak var vuforiaContainerUIView: UIView!
    @IBOutlet weak var maskContainer: UIImageView!
    
    
    var buttonWindow: UIWindow!
    let recorder = RPScreenRecorder.shared()
    var vuforiaView:VuforiaViewController!
    var isRecording:Bool = false
    var videoTransform:CGAffineTransform!
    //let vuforiaContainerPositionY:[CGFloat] = [98,116,265,368]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.settings()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        self.addButtonsControllers()
        UIAnimationsViews.showViewWithAlpha(self, container: self.view, child: vuforiaView)
        self.view.bringSubview(toFront: self.maskContainer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //***********************************************//
    //***************** UI Methods ******************//
    //***********************************************//
    
    func isRecorderAvailable(_ controllers:CamaraButtonsControlViewController){
        
        guard recorder.isAvailable else{
            controllers.videoButtonHide = true
            controllers.photoButtonPositionX  = UIScreen.main.bounds.size.width/2
            return
        }
        

    }
    
    func settings(){
    
        self.showVuforiaView()
        
    }
    

    func showVuforiaView(){
        
        vuforiaView = UIStoryboard(name: Constants.STORYBOARD_IPHONE, bundle: nil).instantiateViewController(withIdentifier: "Vuforia View") as! VuforiaViewController
        
        self.vuforiaView.maskViewDelegate = self
    }
    
    func startAnimationRecordingVideo(_ sender:UIButton){
    
       /*
        UIView.animate(withDuration: 0.5, delay:0, options: [.repeat, .autoreverse], animations: {
            
            sender.alpha = 0.5
            
            
            }, completion: nil)
        
        */
        videoTransform = sender.transform
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            
            sender.transform=CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { (result) in
                
               
        })
        
    }
    
    func stopAnimationRecordingVideo(){
        
        
    }
    
    //***********************************************//
    //*************** Buttons Methods ***************//
    //***********************************************//
    
    func videoActionDelegate(_ sender: UIButton) {
        
        if self.isRecording{
            sender.layer.removeAllAnimations()
            sender.transform = videoTransform
            self.stopVideoRecording(sender)
        }else{
            
            self.starVideoRecording(sender)
        }
    }
    
    func photoActionDelegate(_ sender: UIButton) {
        
        let old = sender.transform
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            
            sender.transform=CGAffineTransform(scaleX: 1.5, y: 1.5)
            sender.alpha = 0.5
            }, completion: { (result) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    sender.transform=old
                    sender.alpha = 1
                })
        })

        
        UIImageWriteToSavedPhotosAlbum(self.view.pb_takeSnapshot(), nil, nil, nil)
    }
    
    //***********************************************//
    //**************** Util Methods *****************//
    //***********************************************//
    
    func changeVideoIconButton(_ button:UIButton){
    
        var image:UIImage!
        if self.isRecording{
            
            image = UIImage(named: "IconVideo")
            
        }else{
            image = UIImage(named: "IconVideoRecord")
        }
        
        button.setImage(image, for: UIControlState())
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
        
        self.buttonWindow = UIWindow(frame: UIScreen.main.bounds)
        let cameraButtonsControllers = UIStoryboard(name: Constants.STORYBOARD_IPHONE, bundle: nil).instantiateViewController(withIdentifier: "Camara Buttons Control") as! CamaraButtonsControlViewController
        cameraButtonsControllers.delegate = self
        self.isRecorderAvailable(cameraButtonsControllers)
        self.buttonWindow.rootViewController = cameraButtonsControllers
        self.buttonWindow.makeKeyAndVisible()
        
    }
    
    func starVideoRecording(_ button:UIButton){
    
        DispatchQueue.main.async(execute: {
            
            guard self.recorder.isAvailable else{
                print("Cannot record the screen")
                return
            }
            
            self.recorder.delegate = self
            
            self.recorder.startRecording(withMicrophoneEnabled: true){err in
                guard err == nil else {
                    if err!._code == RPRecordingErrorCode.userDeclined.rawValue{
                        print("User declined app recording")
                    }
                    else if err!._code == RPRecordingErrorCode.insufficientStorage.rawValue{
                        print("Not enough storage to start recording")
                    }
                    else {
                        print("Error happened = \(err!)")
                    }
                    return
                }
                
                print("Successfully started recording")
                self.changeVideoIconButton(button)
                self.startAnimationRecordingVideo(button)
            }
            
        })
        
        
        

    }
    
    func stopVideoRecording(_ button:UIButton) {
        
      //  self.deInitVuforiaView()
        DispatchQueue.main.async(execute: {
            
            self.recorder.stopRecording{controller, err in
                
                guard let previewController = controller , err == nil else {
                    print("Failed to stop recording")
                    return
                }
                
                self.changeVideoIconButton(button)
                self.buttonWindow.rootViewController!.view.isHidden = true
                previewController.previewControllerDelegate = self
                
                self.present(previewController, animated: true,
                    completion: nil)
                
            }
            
        })
        
        
        
        
    }

    
    //***********************************************//
    //******* Record Preview Delegate Methods *******//
    //***********************************************//
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        print("Finished the preview")
        self.buttonWindow.rootViewController!.view.isHidden = false
        dismiss(animated: true, completion: nil)
        
        //self.showVuforiaView()
    }
    
    func previewController(_ previewController: RPPreviewViewController,didFinishWithActivityTypes activityTypes: Set<String>) {
        print("Preview finished activities \(activityTypes)")
    }
    
    //***********************************************//
    //*********** Record Delegate Methods ***********//
    //***********************************************//
    
    
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("Screen recording availability changed")
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder,
                        didStopRecordingWithError error: Error,
                                                  previewViewController: RPPreviewViewController?) {
        print("Screen recording finished")
    }

    
    //***********************************************//
    //************ Mask Delegate Methods ************//
    //***********************************************//
    
    func pinguinosMask(){
        
        DispatchQueue.main.async {
            self.maskContainer.alpha = 0.5
        }
        
    
    }
    
    func futbolistaMask(){
        
        DispatchQueue.main.async {
            self.maskContainer.alpha = 0
        }
        
        
    }
    
    

}
