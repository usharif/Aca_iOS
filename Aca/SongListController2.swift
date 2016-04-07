//
//  SongListController2.swift
//  Aca
//
//  Created by patron on 4/4/16.
//  Copyright © 2016 Umair Sharif. All rights reserved.
//

import UIKit

class SongListController2: UITableViewController {
    
    var index = 0
    
    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
    var size : [String] = []
    
    @IBAction func deleteSong(sender: AnyObject) {
        let alert1 = UIAlertController(title: "DELETE", message: "Enter the song you'd like to delete.", preferredStyle: .Alert)
        alert1.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "ex: Panda or Pt. 2"
        })
        alert1.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
            let textField = alert1.textFields![0] as UITextField
            let docsDir = self.dirPaths[0] 
            let newDir = (docsDir as NSString).stringByAppendingPathComponent(textField.text!)
            do{
                try NSFileManager.defaultManager().removeItemAtPath(newDir)
            } catch {
                
            }
        }))
        alert1.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
        }))
        self.presentViewController(alert1, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.refreshControl?.addTarget(self, action: #selector(SongListController2.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
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
            let docsDir = self.dirPaths[0]
            let newDir = (docsDir as NSString).stringByAppendingPathComponent("sound.caf")
            do{
                    try NSFileManager.defaultManager().removeItemAtPath(newDir)
            } catch {
                    
                
            }
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(docsDir)
            size = directoryContents
                
            
        } catch {
            
        }
        
        return size.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songCell", forIndexPath: indexPath) as! SongCell2

        // Configure the cell...
        cell.songName.text = size[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        index = indexPath.row
        performSegueWithIdentifier("toIdeas", sender: self)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        let destinationVC = segue.destinationViewController as! IdeaListController2
        
        // Pass the selected object to the new view controller.
        destinationVC.song = size[index]
    }
    

}
