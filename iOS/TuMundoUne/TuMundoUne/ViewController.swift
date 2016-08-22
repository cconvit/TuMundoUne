//
//  ViewController.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 8/21/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let vuforiaLiceseKey = "AVtwaB3/////AAAAGcCvUYrxCUHmvlbK8UK5wX4KdH91d13kAMKaHFaKR7LJIp+Vw+GmgbIFuSoVZgLnOgeqNqMFwdwcw3hpr/Ef67t3sbxCRGp2dqh+/lKWrF1PYdI5GzV4jcrr75RZ761YswOFyx99wG1EizLXaF0f36G1uKomGzy8THmUfrnCj48572VoKcBefnp2BJEXnwU9BgR94lgLunuyZwrPxFcbYurLDpkZt1EMI7emicNv7J1h1Qvh3+uWMsEXz61rJF15bJnfHEtwLe/RrEkWbCuG3b0hibABJdQ+y/lwt+i5tTUYtXf8uR47PVAB9/wsz6WT+Qj7831aM2Sej4yED1fJYM/esze8p3MI/eh8WXnZDy4u"
    let vuforiaDataSetFile = "StonesAndChips.xml"
    
    var vuforiaManager: VuforiaManager? = nil
    
    let boxMaterial = SCNMaterial()
    private var lastSceneName: String? = nil
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        do {
            try vuforiaManager?.stop()
        }catch let error {
            print("\(error)")
        }
    }
}

private extension ViewController {
    func prepare() {
        vuforiaManager = VuforiaManager(licenseKey: vuforiaLiceseKey, dataSetFile: vuforiaDataSetFile)
        if let manager = vuforiaManager {
            manager.delegate = self
            manager.eaglView.sceneSource = self
            manager.eaglView.delegate = self
            manager.eaglView.setupRenderer()
            self.view = manager.eaglView
        }
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(didRecieveWillResignActiveNotification),
                                       name: UIApplicationWillResignActiveNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(didRecieveDidBecomeActiveNotification),
                                       name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        vuforiaManager?.prepareWithOrientation(.Portrait)
    }
    
    func pause() {
        do {
            try vuforiaManager?.pause()
        }catch let error {
            print("\(error)")
        }
    }
    
    func resume() {
        do {
            try vuforiaManager?.resume()
        }catch let error {
            print("\(error)")
        }
    }
}

extension ViewController {
    func didRecieveWillResignActiveNotification(notification: NSNotification) {
        pause()
    }
    
    func didRecieveDidBecomeActiveNotification(notification: NSNotification) {
        resume()
    }
}

extension ViewController: VuforiaManagerDelegate {
    func vuforiaManagerDidFinishPreparing(manager: VuforiaManager!) {
        print("did finish preparing\n")
        
        do {
            try vuforiaManager?.start()
            vuforiaManager?.setContinuousAutofocusEnabled(true)
        }catch let error {
            print("\(error)")
        }
    }
    
    func vuforiaManager(manager: VuforiaManager!, didFailToPreparingWithError error: NSError!) {
        print("did faid to preparing \(error)\n")
    }
    
    func vuforiaManager(manager: VuforiaManager!, didUpdateWithState state: VuforiaState!) {
        for index in 0 ..< state.numberOfTrackableResults {
            let result = state.trackableResultAtIndex(index)
            let trackerableName = result.trackable.name
            //print("\(trackerableName)")
            if trackerableName == "stones" {
                boxMaterial.diffuse.contents = UIColor.redColor()
                
                if lastSceneName != "stones" {
                    manager.eaglView.setNeedsChangeSceneWithUserInfo(["scene" : "stones"])
                    lastSceneName = "stones"
                }
            }else {
                boxMaterial.diffuse.contents = UIColor.blueColor()
                
                if lastSceneName != "chips" {
                    manager.eaglView.setNeedsChangeSceneWithUserInfo(["scene" : "chips"])
                    lastSceneName = "chips"
                }
            }
            
        }
    }
}

extension ViewController: VuforiaEAGLViewSceneSource, VuforiaEAGLViewDelegate {
    
    func sceneForEAGLView(view: VuforiaEAGLView!, userInfo: [String : AnyObject]?) -> SCNScene! {
        guard let userInfo = userInfo else {
            print("default scene")
            return createStonesScene(with: view)
        }
        
        if let sceneName = userInfo["scene"] as? String where sceneName == "stones" {
            print("stones scene")
            return createStonesScene(with: view)
        }else {
            print("chips scene")
            return createChipsScene(with: view)
        }
        
    }
    
    private func createStonesScene(with view: VuforiaEAGLView) -> SCNScene {
        _ = SCNScene()
        
        return SCNScene(named: "Plane.scn")!
        
        /*
         boxMaterial.diffuse.contents = UIColor.lightGrayColor()
         
         let planeNode = SCNNode()
         planeNode.name = "plane"
         planeNode.geometry = SCNPlane(width: 247.0/view.objectScale, height: 173.0/view.objectScale)
         planeNode.position = SCNVector3Make(0, 0, -1)
         let planeMaterial = SCNMaterial()
         planeMaterial.diffuse.contents = UIColor.greenColor()
         planeMaterial.transparency = 0.6
         planeNode.geometry?.firstMaterial = planeMaterial
         scene.rootNode.addChildNode(planeNode)
         
         let boxNode = SCNNode()
         boxNode.name = "box"
         boxNode.geometry = SCNBox(width:1, height:1, length:1, chamferRadius:0.0)
         boxNode.geometry?.firstMaterial = boxMaterial
         scene.rootNode.addChildNode(boxNode)
         
         return scene
         */
    }
    
    private func createChipsScene(with view: VuforiaEAGLView) -> SCNScene {
        
        return SCNScene(named: "Plane.scn")!
        
        /*let scene = SCNScene()
         
         boxMaterial.diffuse.contents = UIColor.lightGrayColor()
         
         let planeNode = SCNNode()
         planeNode.name = "plane"
         planeNode.geometry = SCNPlane(width: 247.0/view.objectScale, height: 173.0/view.objectScale)
         planeNode.position = SCNVector3Make(0, 0, -1)
         let planeMaterial = SCNMaterial()
         planeMaterial.diffuse.contents = UIColor.redColor()
         planeMaterial.transparency = 0.6
         planeNode.geometry?.firstMaterial = planeMaterial
         scene.rootNode.addChildNode(planeNode)
         
         let boxNode = SCNNode()
         boxNode.name = "box"
         boxNode.geometry = SCNBox(width:1, height:1, length:1, chamferRadius:0.0)
         boxNode.geometry?.firstMaterial = boxMaterial
         scene.rootNode.addChildNode(boxNode)
         
         return scene*/
    }
    
    
    func vuforiaEAGLView(view: VuforiaEAGLView!, didTouchDownNode node: SCNNode!) {
        print("touch down \(node.name)\n")
        boxMaterial.transparency = 0.6
    }
    
    func vuforiaEAGLView(view: VuforiaEAGLView!, didTouchUpNode node: SCNNode!) {
        print("touch up \(node.name)\n")
        boxMaterial.transparency = 1.0
    }
    
    func vuforiaEAGLView(view: VuforiaEAGLView!, didTouchCancelNode node: SCNNode!) {
        print("touch cancel \(node.name)\n")
        boxMaterial.transparency = 1.0
    }
}
