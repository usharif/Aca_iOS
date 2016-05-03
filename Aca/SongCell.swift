//
//  SongCell.swift
//  Aca
//
//  Created by patron on 4/4/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import UIKit
import AVFoundation

class SongCell: UITableViewCell, AVAudioPlayerDelegate {
    
    var arrayOfIdeas : [String] = []
    
    var arrayOfAudios = [AVAudioPlayer!]()
    
    var dummy = ""
    
    var dummy1 = ""
    
    var dummy2 = ""
    
    var dum1 = 0
    
    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var songName: UILabel!

    @IBAction func PlayWholeSong(sender: AnyObject) {
        getIdeaNames()
        if dum1 == 0 {
            for index in 0...(arrayOfIdeas.count-1){
                sender.setTitleColor(UIColor.redColor(), forState: .Normal)
                sender.setTitle("Stop", forState: .Normal)
                let newDir1 = (dummy1 as NSString).stringByAppendingPathComponent(arrayOfIdeas[index])
                let newDir2 = (newDir1 as NSString).stringByAppendingPathComponent("sound.caf")
                do {
                    let soundFileURL = NSURL(fileURLWithPath: newDir2)
                    let dumdum = try AVAudioPlayer.init(contentsOfURL: soundFileURL)
                    arrayOfAudios.append(dumdum)
                } catch {
                
                }
                arrayOfAudios[index].delegate = self
                arrayOfAudios[index].prepareToPlay()
                arrayOfAudios[index].numberOfLoops = 20
                arrayOfAudios[index].volume = 1.0
                arrayOfAudios[index].play()
                dum1 = 1
            }
        } else if dum1 == 1 {
            sender.setTitleColor(UIColor.blueColor(), forState: .Normal)
            sender.setTitle("Play", forState: .Normal)
            for index in 0...(arrayOfIdeas.count-1) {
                let newDir1 = (dummy1 as NSString).stringByAppendingPathComponent(arrayOfIdeas[index])
                let newDir2 = (newDir1 as NSString).stringByAppendingPathComponent("sound.caf")
                do {
                    let soundFileURL = NSURL(fileURLWithPath: newDir2)
                    let dumdum = try AVAudioPlayer.init(contentsOfURL: soundFileURL)
                    arrayOfAudios.append(dumdum)
                } catch {
                    
                }
                arrayOfAudios[index].stop()
                arrayOfAudios[index].currentTime = 0
            }
            dum1 = 0
        }
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getIdeaNames() {
        let docsDir = dirPaths[0]
        dummy = songName.text!
        dummy1 = docsDir.stringByAppendingString("/"+dummy)
        do {
            let dir = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(dummy1)
            arrayOfIdeas = dir
        } catch {
            
        }
    }

}
