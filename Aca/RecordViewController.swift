//
//  RecordViewController.swift
//  Aca
//
//  Created by Umair Sharif on 3/20/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    //Class constants
    let RECORD_BUTTON_IMAGE = UIImage.init(named: "RecordButtonImage.png")

    let STOP_RECORD_BUTTON_IMAGE = UIImage.init(named: "StopRecordButtonImage.png")
    
    //Class variables
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var timer = NSTimer()
    //var collection =  Collection()
    
    //Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordProgress: UIProgressView!
    
    //Actions
    @IBAction func StartRecord(sender: AnyObject) {
        audioRecorder.record()
        
        //Updating progress bar after time interval of specific time
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target:self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        
        //Change button when held
        recordButton.setImage(STOP_RECORD_BUTTON_IMAGE, forState: UIControlState.Normal)
    }
    
    @IBAction func EndRecord(sender: AnyObject) {
        audioRecorder.stop()
        //Resets timer and progress bar
        timer.invalidate()
        recordProgress.setProgress(0, animated: true)
        
        //Change button when let go
        recordButton.setImage(RECORD_BUTTON_IMAGE, forState: UIControlState.Normal)
    }
    
    @IBAction func playRecord(sender: AnyObject) {
        preparePlayer()
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        recordProgress.setProgress(0, animated: true)
    }
    
    func getFileURL () -> NSURL {
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir = dirPaths[0]
        let soundFilePath = (docsDir as NSString).stringByAppendingPathComponent("sound.caf")
        
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        return soundFileURL
        
    }
    
    func setupRecorder () {
        
        let recordSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0 ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: getFileURL(),
                settings: recordSettings as! [String : AnyObject])
        } catch {
            
        }
        
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        
    }
    
    func preparePlayer () {
        do {
         audioPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch {
            
        }
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        
    }
    
    func updateProgress() {
        recordProgress.progress += 0.0075
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
