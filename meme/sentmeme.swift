//
//  sentmeme.swift
//  meme
//
//  Created by Amorn Apichattanakul on 5/3/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import Foundation
import UIKit

class sentmeme:UICollectionViewController , UICollectionViewDelegate, UICollectionViewDataSource
{
    let cellReuseIdentifier = "cellCollection"
    var appDelegate:AppDelegate!;
    var flag:Bool = true;

    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
        
        if (appDelegate.memes.count < 1) // no data exist
        {
            editBtn.enabled = false;
        }
        
             self.collectionView?.reloadData();
        
       
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell;
        
        let meme:memeObj = appDelegate.memes[indexPath.item];
        let imageView = UIImageView(image: meme.memeImg);
        cell.backgroundView = imageView
        
        return cell

    }
    @IBAction func removeItem(sender: UIBarButtonItem) {
        if(flag)
        {
            println("remove mode");
            editBtn.title = "Cancel"
            flag = false;
        }
        else
        {
            println("select mode");
            editBtn.title = "Edit"
            flag = true;
        }
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count;
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.row)");
        if(!flag)
        {
            appDelegate.memes.removeAtIndex(indexPath.row);
            collectionView.reloadData();
        }
        else
        {
            println("go");
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewControllerWithIdentifier("showImageController") as! showImageController
            viewController.imageContent = (appDelegate.memes[indexPath.row] as memeObj).memeImg;
            viewController.indexObj = indexPath.row;
            viewController.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(viewController, animated: true);
        }

    }
}
