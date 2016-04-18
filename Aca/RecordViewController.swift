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
    
    var dum = 0
    
    var dum2 = 0
    
    var dummy = ""
    
    var dummy2 = ""
    
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
        
        let alert = UIAlertController(title: "Name the Song", message: "Enter a Song Name", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
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
            if self.dummy.containsString("/") {
                let alert2 = UIAlertController(title: "Not so Fast!", message: "Song Name Cannot Contain a Forward Slash(/)", preferredStyle: .Alert)
                alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                    self.dum = 0
                    self.presentViewController(alert, animated: true, completion: nil)
                }))
                self.presentViewController(alert2, animated: true, completion: nil)
                self.dum = 1
            }
            if self.dum == 0 {
                self.createSongDirectory()
            }
            let alert1 = UIAlertController(title: "Name This Idea", message: "Enter an Idea Name", preferredStyle: .Alert)
            alert1.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                
            })
            alert1.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) -> Void in
                let textField = alert1.textFields![0] as UITextField
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0]
                let newDir = docsDir.stringByAppendingString("/"+self.dummy)
                do{
                    let dir = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(newDir)
                    //if idea name already exists
                    if dir.contains(textField.text!) {
                        let alert4 = UIAlertController(title: "Not so Fast!", message: "Idea Name Already Exists in Song", preferredStyle: .Alert)
                        alert4.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                            self.dum2 = 0
                            self.presentViewController(alert1, animated: true, completion: nil)
                        }))
                        self.presentViewController(alert4, animated: true, completion: nil)
                        self.dum2 = 1
                    }
                } catch {
                    
                }
                self.dummy2 = textField.text!
                if self.dummy2.containsString("/") {
                    let alert3 = UIAlertController(title: "Not so Fast!", message: "Idea Name Cannot Contain a Forward Slash (/)", preferredStyle: .Alert)
                    alert3.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                        self.dum2 = 0
                        self.presentViewController(alert1, animated: true, completion: nil)
                    }))
                    self.presentViewController(alert3, animated: true, completion: nil)
                    self.dum2 = 1
                }
                if self.dum2 == 0 {
                    self.createIdeaDirectory()
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let docsDir = dirPaths[0]
                    let oldDir = (docsDir as NSString).stringByAppendingPathComponent("sound.caf")
                    let newDir = docsDir.stringByAppendingString("/"+self.dummy+"/"+self.dummy2+"/sound.caf")
                    do {
                        try NSFileManager.defaultManager().moveItemAtPath(oldDir, toPath: newDir)
                    } catch {
                        
                    }
                }
            }))
            alert1.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                if self.dum == 0 {
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let docsDir = dirPaths[0]
                    let newDir = (docsDir as NSString).stringByAppendingPathComponent(self.dummy)
                    do{
                        try NSFileManager.defaultManager().removeItemAtPath(newDir)
                    } catch {
                    
                    }
                }
                
            }))
            self.presentViewController(alert1, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
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
