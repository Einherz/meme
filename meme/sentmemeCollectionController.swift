//
//  sentmeme.swift
//  meme
//
//  Created by Amorn Apichattanakul on 5/3/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import Foundation
import UIKit

//Change to more appropaite name from intruction suggestion
//add space between line
//I didn't use variable to get appDelegate object in because I try to use less variable as much as possible, doesn't want to waste memory, maybe i'm wrong

class sentmemeCollectionController:UICollectionViewController {
    
    let cellReuseIdentifier = "cellCollection"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var memeArray = [MemeObj]()
    private var flag = true

    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeArray = appDelegate.memes
        
        if (memeArray.count < 1){ // no data exist
            editBtn.enabled = false
        }
        self.collectionView?.reloadData() //force reload when delete from other view controller
    }
    
    
    @IBAction func removeItem(sender: UIBarButtonItem) {
        if(flag){
            println("remove mode")
            editBtn.title = "Cancel"
            flag = false
        } else {
            println("select mode")
            editBtn.title = "Edit"
            flag = true
        }
    }
}

// MARK: - UICollectionViewDataSource
extension sentmemeCollectionController: UICollectionViewDataSource {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeArray.count
    }
}

// MARK: - UICollectionViewDelegate
extension sentmemeCollectionController: UICollectionViewDelegate {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        println("\(indexPath.row)") // check if I selected the correct row
        if(!flag){
            memeArray.removeAtIndex(indexPath.row)
            collectionView.reloadData() //force reload collectionview when array was removed
        } else {
            println("go")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewControllerWithIdentifier("showImageController") as! showImageController
            viewController.imageContent = (memeArray[indexPath.row] as MemeObj).memeImg
            viewController.indexObj = indexPath.row
            viewController.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        let meme:MemeObj = memeArray[indexPath.item]
        cell.backgroundView = UIImageView(image: meme.memeImg)
        
        return cell
        
    }
}
