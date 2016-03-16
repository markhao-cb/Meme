//
//  MemeTableViewController.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/15/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")! as UITableViewCell
        let meme = memes[indexPath.row]
        
        
        return cell
    }

}
