//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/15/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class MemeCollectionViewController: MemeViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //MARK: UIViewController delegate methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space :CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeCollectionView.reloadData()
    }
    
    //MARK: UICollectionView DataSource & delegate methods

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "viewDetail" {
            let detailViewController = segue.destinationViewController as! MemeDetailViewController
            let cell = sender as! MemeCollectionViewCell
            let indexPath = memeCollectionView.indexPathForCell(cell)
            let selectedMeme = memes[(indexPath?.row)!]
            detailViewController.meme = selectedMeme
        }
        
    }
    
    
    
    
}
