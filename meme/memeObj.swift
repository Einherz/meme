//
//  memeObj.swift
//  meme
//
//  Created by Amorn Apichattanakul on 5/2/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import Foundation
import UIKit

class memeObj {
    var originalImg:UIImage!;
    var memeImg:UIImage!;
    var textMeme:NSString!;
    
    init(textMeme: NSString, originalImg:UIImage,memeImg:UIImage )
    {
        self.textMeme = textMeme;
        self.originalImg = originalImg;
        self.memeImg = memeImg;
    }
}
