//
//  sentmemeTable.swift
//  meme
//
//  Created by Amorn Apichattanakul on 5/3/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//


import Foundation
import UIKit

class sentmemeTableController:UITableViewController {
    let cellReuseIdentifier = "cellTable"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    private var memeArray = [MemeObj]();
    private var flag = true;
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        memeArray = appDelegate.memes;
        editBtn.title = "Edit"
        
        if (memeArray.count < 1){ // no data exist
            editBtn.enabled = false;
        }
        self.tableView.reloadData();
    }
    
    @IBAction func removeItem(sender: UIBarButtonItem) {
        
        if(flag){
            println("remove mode");
            editBtn.title = "Cancel"
            flag = false;
        } else {
            println("select mode");
            editBtn.title = "Edit"
            flag = true;
        }
    }
}

// MARK: - UICollectionViewDataSource
extension sentmemeTableController: UITableViewDataSource {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  memeArray.count;
    }
}

extension sentmemeTableController: UITableViewDelegate {
    //override func tabl
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell =  tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as! UITableViewCell
        
        let obj:MemeObj = memeArray[indexPath.row];
        
        cell.imageView?.image = obj.memeImg;
        cell.textLabel?.text =  obj.textMeme as String;
        cell.detailTextLabel?.text = obj.subTextMeme as String;
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.row)");
        if(!flag){
            appDelegate.memes.removeAtIndex(indexPath.row);
            tableView.reloadData();
        } else {
            println("go");
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var viewController = storyboard.instantiateViewControllerWithIdentifier("showImageController") as! showImageController
            viewController.imageContent = (appDelegate.memes[indexPath.row] as MemeObj).memeImg;
            viewController.indexObj = indexPath.row;
            viewController.hidesBottomBarWhenPushed = true;
            
            self.navigationController?.pushViewController(viewController, animated: true);
        }
    }
}
