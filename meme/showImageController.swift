//
//  showImageController.swift
//  meme
//
//  Created by Amorn Apichattanakul on 5/9/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import Foundation
import UIKit

class showImageController: UIViewController {
    
    internal var imageContent: UIImage?;
    internal var indexObj: Int?;
    private var appDelegate: AppDelegate!;
    @IBOutlet weak var imageDisplay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
        imageDisplay.image = imageContent;
    }
    
    @IBAction func backToParent(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func removeItem(sender: UIBarButtonItem) {
        appDelegate.memes.removeAtIndex(indexObj!);
        self.navigationController?.popToRootViewControllerAnimated(true);
        
    }
    
    @IBAction func EditItem(sender: UIBarButtonItem) {
        let destination:memeEditorController = self.storyboard!.instantiateViewControllerWithIdentifier("memeEditor") as! memeEditorController;
        self.presentViewController(destination, animated: true, completion: nil);
    }
}
