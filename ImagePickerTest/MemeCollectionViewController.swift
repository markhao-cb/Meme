//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/15/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
