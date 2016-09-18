//
//  SoundsEffects.swift
//  TuMundoUne
//
//  Created by Carlos Convit on 9/16/16.
//  Copyright © 2016 Iniciativa Publicitaria. All rights reserved.
//

import Foundation
import AVFoundation

class SoundsEffects: NSObject{
    
    
     static let SoundsEffectsManager = SoundsEffects()
     
    var audioPlayerPinguino:AVAudioPlayer!
    var audioPlayerFutbol:AVAudioPlayer!
     
     override init(){

        let session = AVAudioSession.sharedInstance()
        

        
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try session.setActive(true)

            let soundWindFileURL:URL = Bundle.main.url(forResource: "Wind", withExtension: "mp3")!
            let soundCrowdFileURL:URL = Bundle.main.url(forResource: "Crowd", withExtension: "mp3")!
            
            try audioPlayerPinguino = AVAudioPlayer(contentsOf: soundWindFileURL)
            audioPlayerPinguino.prepareToPlay()
            audioPlayerPinguino.numberOfLoops = -1
            audioPlayerPinguino.volume = 4
            
            try audioPlayerFutbol = AVAudioPlayer(contentsOf: soundCrowdFileURL)
            audioPlayerFutbol.prepareToPlay()
            audioPlayerFutbol.numberOfLoops = -1
            audioPlayerFutbol.volume = 4
            
            
        }catch {
            print("Error getting the audio file")
        }
        
     }
     
     static func playPinguinos(){
     
        SoundsEffects.SoundsEffectsManager.audioPlayerFutbol.stop()
        SoundsEffects.SoundsEffectsManager.audioPlayerPinguino.play()
     }
    
    static func playFutbolista(){
        
        SoundsEffects.SoundsEffectsManager.audioPlayerPinguino.stop()
        SoundsEffects.SoundsEffectsManager.audioPlayerFutbol.play()
        
    }
    
    static func stopAll(){
        
        SoundsEffects.SoundsEffectsManager.audioPlayerPinguino.stop()
        SoundsEffects.SoundsEffectsManager.audioPlayerFutbol.stop()
        
    }
 
}
