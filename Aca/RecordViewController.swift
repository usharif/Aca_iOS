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
    var dum = 0
    var dummy = ""
    var dummy2 = ""
    
    //Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordProgress: UIProgressView!
    
    //Actions
    @IBAction func StartRecord(sender: AnyObject) {
        audioRecorder.record()
        
        //Updating progress bar after time interval of specific time
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target:self, selector: #selector(RecordViewController.updateProgress), userInfo: nil, repeats: true)
        
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
        
        let songAlert = UIAlertController(title: "Recording Saved!", message: "Add to previous song or create new song?", preferredStyle: .Alert)
        songAlert.addAction(UIAlertAction(title: "Add to Song", style: .Default, handler: { (action) -> Void in
            //choose from list of current songs
        }))
        
        songAlert.addAction(UIAlertAction(title: "New song", style: .Default, handler: {(action) -> Void in
            let newSongAlert = UIAlertController(title: "Song created!", message: "Please name your song", preferredStyle: .Alert)
            newSongAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                newSongAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: {(action) -> Void in
                    let textField = newSongAlert.textFields![0] as UITextField
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let docsDir = dirPaths[0]
                    do{
                        let dir = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(docsDir)
                        if dir.contains(textField.text!) {
                            self.dum = 1
                        }
                    } catch {
                        
                    }
                    self.dummy = textField.text!
                    if self.dum == 0 {
                        self.createSongDirectory()
                    }
                    
                    let ideaAlert = UIAlertController(title: "Name this Idea", message: "Enter an Idea Name", preferredStyle: .Alert)
                    ideaAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                        //textField.text = "ex: Panda or Pt. 2"
                    })
                    
                    ideaAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) -> Void in
                        let textField = ideaAlert.textFields![0] as UITextField
                        self.dummy2 = textField.text!
                        self.createIdeaDirectory()
                        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                        let docsDir = dirPaths[0]
                        let oldDir = (docsDir as NSString).stringByAppendingPathComponent("sound.caf")
                        let newDir = docsDir.stringByAppendingString("/"+self.dummy+"/"+self.dummy2+"/sound.caf")
                        do {
                            try NSFileManager.defaultManager().moveItemAtPath(oldDir, toPath: newDir)
                        } catch {
                            
                        }
                    }))
                    ideaAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                        
                    }))
                    self.presentViewController(ideaAlert, animated: true, completion: nil)
                    
                }))
                newSongAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                }))
                self.presentViewController(newSongAlert, animated: true, completion: nil)
            })
            
        }))
        songAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
        }))
        self.presentViewController(songAlert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        recordProgress.setProgress(0, animated: true)
    }
    
    func getFileURL () -> NSURL {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0]
        let soundFilePath = (docsDir as NSString).stringByAppendingPathComponent("sound.caf")
        
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        return soundFileURL
        
    }
    
    func createSongDirectory () {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0]
        let newDir = docsDir.stringByAppendingString("/"+dummy)
        do{
            try NSFileManager.defaultManager().createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
    }
    
    func createIdeaDirectory () {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0]
        let newDir = docsDir.stringByAppendingString("/"+dummy+"/"+dummy2)
        do{
            try NSFileManager.defaultManager().createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
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
