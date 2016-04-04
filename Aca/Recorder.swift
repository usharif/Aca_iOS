//  Recorder.swift
//  Aca
//
//  Created by Umair Sharif on 3/26/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.

import UIKit
import Foundation
import AVFoundation

class Recorder {
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var timer = NSTimer()

    
    func startRecord() {
        let recordSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: getFileURL(),
                settings: recordSettings as! [String : AnyObject])
        } catch {
            
        }
        
        //audioRecorder.delegate
        audioRecorder.prepareToRecord()
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
    
    func preparePlayer () {
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch {
            
        }
        
//        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        
    }
}