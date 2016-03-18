//
//  Utilities.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/17/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {
    static var appDelegate : AppDelegate  {
        get {
            let object = UIApplication.sharedApplication().delegate
            return object as! AppDelegate
        }
    }
}
