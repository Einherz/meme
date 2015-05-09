//
//  sentmemeTable.swift
//  meme
//
//  Created by Amorn Apichattanakul on 5/3/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//


import Foundation
import UIKit

class sentmemeTable:UITableViewController,UITableViewDelegate, UITableViewDataSource
{
    let cellReuseIdentifier = "cellTable"
    var flag:Bool = true;
    var appDelegate:AppDelegate!;
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
        editBtn.title = "Edit"
        
        if (appDelegate.memes.count < 1) // no data exist
        {
            editBtn.enabled = false;
        }
        self.tableView.reloadData();
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  appDelegate.memes.count;
    }
   
    
    //override func tabl
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell =  tableView.dequeueReusableCellWithIdentifier(self.cellReuseIdentifier) as! UITableViewCell
        
        let obj:memeObj = appDelegate.memes[indexPath.row];
        
        cell.imageView?.image = obj.memeImg;
        cell.textLabel?.text =  obj.textMeme as String;
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.row)");
       if(!flag)
       {
        appDelegate.memes.removeAtIndex(indexPath.row);
        tableView.reloadData();
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
