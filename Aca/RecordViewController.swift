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
    
    /* Class constants */
    let RECORD_BUTTON_IMAGE = UIImage.init(named: "RecordButtonImage.png")
    let STOP_RECORD_BUTTON_IMAGE = UIImage.init(named: "StopRecordButtonImage.png")
    
    /* Class variables */
    //Audio recorder and player
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    //Timer for progress bar
    var timer = NSTimer()
    
    //Variables for saving purposes
    var recordedAudio: RecordedAudio!
    var newSong: Song!
    var newIdea: Idea!
    
    /* UIAlert controller & actions */
    var alertController = UIAlertController(title: "Recording saved!", message: "Please name your recording and choose a type", preferredStyle: .Alert)
    var songChoiceAction = UIAlertAction(title: "Song", style: UIAlertActionStyle.Default) {
     UIAlertAction in
    }
    var ideaChoiceAction = UIAlertAction(title: "Idea", style: UIAlertActionStyle.Default) {
        UIAlertAction in
    }
    
    /* Interface Builder outlets */
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordProgress: UIProgressView!
    var alertTextField: UITextField!
    
    /* Interface Builder actions */
    @IBAction func StartRecord(sender: AnyObject) {
        audioRecorder.record()
        
        //Updating progress bar after time interval of specific time
        timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target:self, selector: #selector(RecordViewController.updateProgress), userInfo: nil, repeats: true)
        
        //Change button when held
        recordButton.setImage(STOP_RECORD_BUTTON_IMAGE, forState: UIControlState.Normal)
    }
    @IBAction func saveButton(sender: AnyObject) {
        audioRecorderDidFinishRecording(audioRecorder, successfully: true)
        self.presentViewController(alertController, animated: true, completion: nil)
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
    
    @IBAction func discardButton(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        recordProgress.setProgress(0, animated: true)

        alertController.addAction(UIAlertAction(title: "Song",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in self.createNewSong(self.alertTextField.text!)}))
        alertController.addAction(UIAlertAction(title: "Idea",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in self.createNewIdea(self.alertTextField.text!)}))
        alertController.addTextFieldWithConfigurationHandler(configurationTextField)
    }
    
    func configurationTextField(textField: UITextField!) {
        self.alertTextField = textField!
    }
    
    func createNewSong(name: String) {
        newSong = Song(name: name, recordedAudio: recordedAudio)
        arrayOfSongs.append(newSong)
    }
    
    func createNewIdea(name: String) {
        newIdea = Idea(name: name, recordedAudio: recordedAudio)
        //find song and add to song
        print(newIdea.name)
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
    
    func audioRecorderDidFinishRecording(audioRecorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
            
            //Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = audioRecorder.url
            
        }
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
