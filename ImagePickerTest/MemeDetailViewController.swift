//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/17/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: MemeViewController {
    
    var meme: Meme?
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    //MARK: UIViewController delegate methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide tabbar
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show tabbar
        tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme")
        
        if let meme = meme {
            memeDetailImageView.image = meme.memedImage
        }
    }
    
    //MARK: Selectors
    
    func editMeme() {
        addOrEditMeme(meme)
    }
    
}