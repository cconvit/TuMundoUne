//
//  SceneLoader.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 9/14/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import Foundation

class SceneLoader: NSObject{
    
    
    static let SceneLoaderManager = SceneLoader()

    var serialQueue:DispatchQueue!
    var futbolistaEucol:SCNScene!
    var pinguinosEucol:SCNScene!
    
    
    override init(){
        print()

        self.serialQueue = DispatchQueue(label: "Scene Loader")
    }
    
    static func loadScenes(){
    
        DispatchQueue.main.async {
            SceneLoader.SceneLoaderManager.pinguinosEucol = SCNScene(named: "PinguinosEucol.scn")
        }
        /*        SceneLoader.SceneLoaderManager.serialQueue.async {
            
           

            SceneLoader.SceneLoaderManager.pinguinosEucol = SCNScene(named: "PinguinosEucol.scn")
            
        }
 */
 }
}
