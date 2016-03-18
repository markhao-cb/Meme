//
//  Meme.swift
//  Meme
//
//  Created by Yu Qi Hao on 3/13/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    func isEqualTo(meme: Meme) -> Bool {
        return topText == meme.topText && bottomText == meme.bottomText && originalImage == meme.originalImage && memedImage == meme.memedImage
    }
}
