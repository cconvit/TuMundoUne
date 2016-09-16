//
//  VuforiaViewController.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 9/13/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import UIKit

class VuforiaViewController: UIViewController {

    var vuforiaManager: VuforiaManager? = nil
    var maskViewDelegate:MaskViewDelegate!
    fileprivate var lastSceneName: String? = nil
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        vuforiaManager = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        prepare()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
}

private extension VuforiaViewController {
    func prepare() {
        vuforiaManager = VuforiaManager(licenseKey: Constants.VUFORIA_KEY, dataSetFile: Constants.VUFORIA_DATASET)
        if let manager = vuforiaManager {
            manager.delegate = self
            manager.eaglView.sceneSource = self
            manager.eaglView.delegate = self
            manager.eaglView.setupRenderer()
            self.view = manager.eaglView
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didRecieveWillResignActiveNotification),
                                       name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(didRecieveDidBecomeActiveNotification),
                                       name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        vuforiaManager?.prepare(with: .portrait)
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

extension VuforiaViewController {
    func didRecieveWillResignActiveNotification(_ notification: Notification) {
        pause()
    }
    
    func didRecieveDidBecomeActiveNotification(_ notification: Notification) {
        resume()
    }
}

extension VuforiaViewController: VuforiaManagerDelegate {
    
    public func vuforiaManager(_ manager: VuforiaManager!, didFailToPreparingWithError error: Error!) {
        print("did faid to preparing \(error)\n")
    }
    
    func vuforiaManagerDidFinishPreparing(_ manager: VuforiaManager!) {
        print("did finish preparing\n")
        
        do {
            try vuforiaManager?.start()
            vuforiaManager?.setContinuousAutofocusEnabled(true)
        }catch let error {
            print("\(error)")
        }
    }
    
    
    func vuforiaManager(_ manager: VuforiaManager!, didUpdateWith state: VuforiaState!) {
        
        for index in 0 ..< state.numberOfTrackableResults {
            let result = state.trackableResult(at: index)
            let trackerableName = result?.trackable.name
            //print("\(trackerableName)")
            
            switch trackerableName{
            
                case "IMPRESO_PINGUINO_NETFLIX_ADN_UNE_STRAGE-25-5x8-5cm"?:
                    setSceneContent(manager,sceneName: "PinguinosImpreso")
                break
                
                case "IMPRESO_PINGUINO_NETFLIX_PRENSA_UNE_DARE-12-6x34cm"?:
                    setSceneContent(manager,sceneName: "PinguinosImpreso")
                break
                
                case "IMPRESO_PINGUINO_NETFLIX_SEMANA_UNE_STRANGER-20-5x27-5cm"?:
                    setSceneContent(manager,sceneName: "PinguinosImpreso")
                break
                
                case "IMPRESO_PINGUINO_NETFLIX_SOHO_UNE_HOUSE-23x9cm"?:
                    setSceneContent(manager,sceneName: "PinguinosImpreso")
                break
                
                case "IMPRESO_PINGUINO_NETFLIX_VEA_UNE_DARE-26x34-5cm"?:
                    setSceneContent(manager,sceneName: "PinguinosImpreso")
                break
                
                case "PARADERO_FUTBOL_NETFLIX_UNE_HOUSE"?:
                    setSceneContent(manager,sceneName: "FutbolistaEucol")
                break
                
                default:
                    self.maskViewDelegate.futbolistaMask()
                break
            
            }
            
        }
    }
    
    func setSceneContent(_ manager: VuforiaManager!,sceneName:String){
        
        if lastSceneName != sceneName{
            
            switch sceneName{
                
                case "PinguinosImpreso":
                    self.maskViewDelegate.pinguinosMask()
                break
                
                case "FutbolistaEucol":
                    self.maskViewDelegate.futbolistaMask()
                break
                
                default:
                break
            }
            
            
            manager.eaglView.setNeedsChangeSceneWithUserInfo(["scene" : sceneName])
            lastSceneName = sceneName
            
        }
        
    }
}

extension VuforiaViewController: VuforiaEAGLViewSceneSource, VuforiaEAGLViewDelegate {
    public func scene(for view: VuforiaEAGLView!, userInfo: [String : Any]! = [:]) -> SCNScene! {
        
        guard let userInfo = userInfo else {
            print("default scene")
            return createFutbolistaEucolScene(with: view)
        }
        
        let sceneName = userInfo["scene"] as? String
        
        switch sceneName{
        
            case "FutbolistaEucol"?:
                return createFutbolistaEucolScene(with: view)
            
            case "PinguinosImpreso"?:
                return createPinguinosImpresoScene(with: view)
            
            default:
                return createFutbolistaEucolScene(with: view)
            
        }
        
    }
    

    fileprivate func createFutbolistaEucolScene(with view: VuforiaEAGLView) -> SCNScene {
        

        
        return SCNScene(named: "FutbolistaEucol.scn")!
    }
    
    fileprivate func createPinguinosEucolScene(with view: VuforiaEAGLView) -> SCNScene {
        
        
        //return SceneLoader.SceneLoaderManager.pinguinosEucol
       return SCNScene(named: "PinguinosEucol.scn")!
    }
    
    fileprivate func createPinguinosImpresoScene(with view: VuforiaEAGLView) -> SCNScene {
        
        
        //return SceneLoader.SceneLoaderManager.pinguinosEucol
        return SCNScene(named: "PinguinosImpreso.scn")!
    }
    
    
    func vuforiaEAGLView(_ view: VuforiaEAGLView!, didTouchDownNode node: SCNNode!) {
        print("touch down \(node.name)\n")
 
    }
    
    func vuforiaEAGLView(_ view: VuforiaEAGLView!, didTouchUp node: SCNNode!) {
        print("touch up \(node.name)\n")
  
    }
    
    func vuforiaEAGLView(_ view: VuforiaEAGLView!, didTouchCancel node: SCNNode!) {
        print("touch cancel \(node.name)\n")

    }
}
