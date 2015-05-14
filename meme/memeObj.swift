//
//  memeObj.swift
//  meme
//
//  Created by Amorn Apichattanakul on 5/2/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import Foundation
import UIKit

struct MemeObj {
    internal var originalImg:UIImage!
    internal var memeImg:UIImage!
    internal var textMeme:NSString!
    internal var subTextMeme:NSString!

    
    init(textMeme: NSString, subTextMeme:NSString, originalImg:UIImage, memeImg:UIImage )
    {
        self.textMeme = textMeme
        self.subTextMeme = subTextMeme
        self.originalImg = originalImg
        self.memeImg = memeImg
    }
}
