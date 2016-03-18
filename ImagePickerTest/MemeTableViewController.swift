//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/15/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class MemeTableViewController: MemeViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    @IBOutlet weak var memeTableView: UITableView!
    
    //MARK: UIViewController delegate methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeTableView.reloadData()
    }
    
    
    //MARK: UITableView datasource & delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")! as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.memeImageView.image = meme.memedImage
        
        cell.memeLabel.text = meme.topText + " " + meme.bottomText
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            removeMemeFromAppDelegate(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "viewDetail" {
            let detailViewController = segue.destinationViewController as! MemeDetailViewController
            let indexPath = memeTableView.indexPathForSelectedRow!
            let selectedMeme = memes[indexPath.row]
            detailViewController.meme = selectedMeme
        }
        
    }
    
}
