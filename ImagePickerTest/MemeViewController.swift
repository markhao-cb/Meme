//
//  MemeViewController.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/16/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import UIKit

class MemeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
        
        //create "Add" button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addMeme")
        
    }

    
    func addMeme() {
        addOrEditMeme(nil)
    }
    
    func addOrEditMeme(editMeme:Meme?) {
        let memeEditor = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        if let meme = editMeme {
            memeEditor.topString = meme.topText
            memeEditor.bottomString = meme.bottomText
            memeEditor.originalImage = meme.originalImage
        }
        presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    func removeMemeFromAppDelegate(index: Int) {
        Utilities.appDelegate.memes.removeAtIndex(index)
    }
}

