//
//  RecordViewController.swift
//  Aca
//
//  Created by Umair Sharif on 3/20/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dum = 0
    
    var dum2 = 0
    
    var dummy = ""
    
    var dummy2 = ""
    
    //Class constants
    let RECORD_BUTTON_IMAGE = UIImage.init(named: "RecordButtonImage.png")
    let STOP_RECORD_BUTTON_IMAGE = UIImage.init(named: "StopRecordButtonImage.png")
    let WAVE_COLOR = UIColor(red: 160.0/255.0, green: 25.0/255.0, blue: 39.0/255.0, alpha: 1.0)
    
    //Class variables
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    //Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var waveForm: SCSiriWaveformView!
    
    //Actions
    @IBAction func StartRecord(sender: AnyObject) {
       audioRecorder.record()
        waveForm.waveColor = WAVE_COLOR

        //Change button when held
        recordButton.setImage(STOP_RECORD_BUTTON_IMAGE, forState: UIControlState.Normal)
    }
    
    @IBAction func EndRecord(sender: AnyObject) {
        audioRecorder.stop()
        waveForm.waveColor = UIColor.clearColor()
        
        //Change button when let go
        recordButton.setImage(RECORD_BUTTON_IMAGE, forState: UIControlState.Normal)
        
        let songAlert = UIAlertController(title: "Recording saved!", message: "Create new song or add to previous song?", preferredStyle: .Alert)
        
        songAlert.addAction(UIAlertAction(title: "New song", style: .Default, handler: { (action) -> Void in
            let newSongAlert = UIAlertController(title: "Name the Song", message: "Enter a Song Name", preferredStyle: .Alert)
            newSongAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                
            })
            newSongAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
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
                if self.dummy.containsString("/") {
                    let songNameErrorAlert = UIAlertController(title: "Not so Fast!", message: "Song Name Cannot Contain a Forward Slash(/)", preferredStyle: .Alert)
                    songNameErrorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                        self.dum = 0
                        self.presentViewController(newSongAlert, animated: true, completion: nil)
                    }))
                    self.presentViewController(songNameErrorAlert, animated: true, completion: nil)
                    self.dum = 1
                }
                if self.dum == 0 {
                    self.createSongDirectory()
                }
                let ideaAlert = UIAlertController(title: "Name This Idea", message: "Enter an Idea Name", preferredStyle: .Alert)
                ideaAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                    
                })
                ideaAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) -> Void in
                    let textField = ideaAlert.textFields![0] as UITextField
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let docsDir = dirPaths[0]
                    let newDir = docsDir.stringByAppendingString("/"+self.dummy)
                    do{
                        let dir = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(newDir)
                        //if idea name already exists
                        if dir.contains(textField.text!) {
                            let ideaAlreadyExistsErrorAlert = UIAlertController(title: "Not so Fast!", message: "Idea Name Already Exists in Song", preferredStyle: .Alert)
                            ideaAlreadyExistsErrorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                                self.dum2 = 0
                                self.presentViewController(ideaAlert, animated: true, completion: nil)
                            }))
                            self.presentViewController(ideaAlreadyExistsErrorAlert, animated: true, completion: nil)
                            self.dum2 = 1
                        }
                    } catch {
                        
                    }
                    self.dummy2 = textField.text!
                    if self.dummy2.containsString("/") {
                        let ideaNameErrorAlert = UIAlertController(title: "Not so Fast!", message: "Idea Name Cannot Contain a Forward Slash (/)", preferredStyle: .Alert)
                        ideaNameErrorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                            self.dum2 = 0
                            self.presentViewController(ideaAlert, animated: true, completion: nil)
                        }))
                        self.presentViewController(ideaNameErrorAlert, animated: true, completion: nil)
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
                ideaAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
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
                self.presentViewController(ideaAlert, animated: true, completion: nil)
            }))
            
            newSongAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            }))
            
            self.presentViewController(newSongAlert, animated: true, completion: nil)
        }))
        
        songAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) -> Void in
        }))
        
        songAlert.addAction(UIAlertAction(title: "Add to previous song", style: .Default, handler: { (action) -> Void in
            self.showPickerInActionSheet()
        }))
        
        self.presentViewController(songAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    
        let displaylink = CADisplayLink(target: self, selector: NSSelectorFromString("updateMeters"))
        displaylink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
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
        audioRecorder.meteringEnabled = true
    }
    
    func updateMeters() {
        var normalizedValue: CGFloat
        audioRecorder.updateMeters()
        normalizedValue = self.normalizedPowerLevelFromDecibels(CGFloat(audioRecorder.averagePowerForChannel(0)))
        self.waveForm.updateWithLevel(normalizedValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func normalizedPowerLevelFromDecibels(decibels: CGFloat) -> CGFloat {
        if (decibels < -60.0 || decibels == 0.0) {
            return 0.0;
        }
        
        return CGFloat(powf((powf(10.0, 0.05 * float_t(decibels)) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0));
    }
    
    func showPickerInActionSheet() {
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet);
        alert.modalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRectMake(40, 52, 270, 100); // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);
        
        
        //set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
        
        //Add the picker to the alert controller
        alert.view.addSubview(picker);
        
        //Create the toolbar view - the view witch will hold our 2 buttons
        let toolFrame = CGRectMake(40, 5, 270, 45);
        let toolView: UIView = UIView(frame: toolFrame);
        
        //add buttons to the view
        let buttonCancelFrame: CGRect = CGRectMake(0, 7, 100, 30); //size & position of the button as placed on the toolView
        
        //Create the cancel button & set its title
        let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
        buttonCancel.setTitle("Cancel", forState: UIControlState.Normal);
        buttonCancel.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal);
        toolView.addSubview(buttonCancel); //add it to the toolView
        
        //Add the target - target, function to call, the event witch will trigger the function call
        buttonCancel.addTarget(self, action: #selector(RecordViewController.cancelSelection(_:)), forControlEvents: UIControlEvents.TouchDown);
        
        //add buttons to the view
        let buttonChooseFrame: CGRect = CGRectMake(170, 7, 100, 30); //size & position of the button as placed on the toolView
        
        //Create the Select button & set the title
        let buttonChoose: UIButton = UIButton(frame: buttonChooseFrame);
        buttonChoose.setTitle("Select", forState: UIControlState.Normal);
        buttonChoose.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal);
        toolView.addSubview(buttonChoose); //add to the subview
        
        //Add the tartget. In my case I dynamicly set the target of the select button
        buttonChoose.addTarget(self, action: #selector(RecordViewController.chooseSong(_:)), forControlEvents: UIControlEvents.TouchDown);
        
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
        
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    func chooseSong(sender: UIButton){
        // Your code when select button is tapped
        print("im working")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //number of songs
        return size.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return size[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Do something if selected
    }
    
    func cancelSelection(sender: UIButton){
        print("Cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
        // We dismiss the alert. Here you can add your additional code to execute when cancel is pressed
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
