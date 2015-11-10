//
//  PlaySoundViewController.swift
//  
//
//  Created by Diego Gomes on 26/10/2015.
//
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    //variable global
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngene:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if var filePath = NSBundle.mainBundle().pathForResource("Hole", ofType: "aiff"){
//           var filePathUrl = NSURL.fileURLWithPath(filePath)
//            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
//            audioPlayer.enableRate = true
//        }else{
//            println("This file empty")
//        }
        
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngene = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSandSlow(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    
    @IBAction func coelhoPlay(sender: UIButton) {
        playAudioWithVariablePith(1000)
    }
    
    func playAudioWithVariablePith(pitch: Float){
        audioPlayer.stop()
        audioEngene.stop()
        audioEngene.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngene.attachNode(audioPlayerNode)
        
        var changePithEffect = AVAudioUnitTimePitch()
        changePithEffect.pitch = pitch
        audioEngene.attachNode(changePithEffect)
        
        audioEngene.connect(audioPlayerNode, to: changePithEffect, format: nil)
        audioEngene.connect(changePithEffect, to: audioEngene.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngene.startAndReturnError()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePith(-1000)
    }
    
    
    @IBAction func stopSoundbt(sender: UIButton) {
        audioPlayer.stop()
    }
    
}
