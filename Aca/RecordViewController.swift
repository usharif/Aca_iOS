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
    
    var audioRecorder: AVAudioRecorder!
    
    var audioPlayer: AVAudioPlayer!
    
    
    @IBAction func StartRecord(sender: AnyObject) {
        audioRecorder.record()
    }
    
    @IBAction func EndRecord(sender: AnyObject) {
        audioRecorder.stop()
        
        // code borrowed from Stack Overflow
        let alert = UIAlertController(title: "Idea Name", message: "Name Your Idea", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "Some default text."
        })
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .Default, handler: { (action) -> Void in
            //do nothing
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func playRecord(sender: AnyObject) {
        preparePlayer()
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()

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
