//
//  IdeaListController2.swift
//  Aca
//
//  Created by patron on 4/4/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import UIKit
import AVFoundation

class IdeaListController2: UITableViewController, AVAudioPlayerDelegate {
    
    var play = ""
    
    var audioPlayer: AVAudioPlayer!
    
    var song = ""
    
    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
    var size : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.refreshControl?.addTarget(self, action: #selector(IdeaListController2.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        do {
            let docsDir = dirPaths[0]
            let newDir = docsDir.stringByAppendingString("/"+song)
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(newDir)
            size = directoryContents
        } catch {
            
        }
        
        return size.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ideaCell", forIndexPath: indexPath) as! IdeaCell2

        // Configure the cell...
        
        cell.ideaName.text = size[indexPath.row]

        return cell
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func preparePlayer () {
        do {
            let soundFileURL = NSURL(fileURLWithPath: play)
            audioPlayer = try AVAudioPlayer(contentsOfURL: soundFileURL)
        } catch {
            
        }
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let docsDir = dirPaths[0]
        let newDir = docsDir.stringByAppendingString("/"+song)
        let newDir1 = (newDir as NSString).stringByAppendingPathComponent(size[indexPath.row])
        let newDir2 = (newDir1 as NSString).stringByAppendingPathComponent("sound.caf")
        play = newDir2
        print(play)
        preparePlayer()
        audioPlayer.play()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
