//
//  RecordSounViewController.swift
//  Rec2
//
//  Created by Diego Gomes on 26/10/2015.
//  Copyright (c) 2015 Nylon. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSounViewController: UIViewController,AVAudioRecorderDelegate{
    @IBOutlet weak var gravandoLabel: UILabel!
    @IBOutlet weak var pauseLabel: UIButton!
    @IBOutlet weak var pauseBt: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordeAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recBt(sender: UIButton) {
        gravandoLabel.hidden = false
        pauseLabel.hidden = false
        pauseBt.enabled = true
       
        //let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask,true)[0] as String
        let dirPath: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recodingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath,recodingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //setup audio
        var session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        
        //initialize and prepare the recorder
        audioRecorder = try? AVAudioRecorder(URL: filePath, settings: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
            //Step one  save the record audio
            recordeAudio = RecordedAudio()
            recordeAudio.filePathUrl = recorder.url
            recordeAudio.title = recorder.url.lastPathComponent
            
            //step two  move to  the next  scene perfom segue
            self.performSegueWithIdentifier("stopRecording", sender: recordeAudio)
        }else{
            print("Recording was not Sucessful")
            gravandoLabel.enabled = true
            pauseBt.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func pauseBt(sender: UIButton) {
        audioRecorder.stop()
        
    }
    
    
}

