//
//  ViewController.swift
//  meme
//
//  Created by Amorn Apichattanakul on 4/25/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var topTxt: UITextField!
    @IBOutlet weak var bottomTxt: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var meme:memeObj!;
    var memedImage:UIImage!;
    var tempStr:String?;
    var activeField:UITextField?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set Text
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        
        topTxt.text = "TOP";
        topTxt.delegate = self;
        topTxt.defaultTextAttributes = memeTextAttributes;
        topTxt.textAlignment = NSTextAlignment.Center;
        
        bottomTxt.text = "BOTTOM";
        bottomTxt.delegate = self;
        bottomTxt.defaultTextAttributes = memeTextAttributes;
        bottomTxt.textAlignment = NSTextAlignment.Center;

        
        //tap on anything to hide keyboard
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture);
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
         self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        self.unsubscribeFromKeyboardNotifications();
    }
    
    func generateMemedImage() -> UIImage
    {
        print("generate Image");
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.navigationController?.setToolbarHidden(true, animated: true);
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.setToolbarHidden(false, animated: true);
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        meme = memeObj(textMeme: topTxt.text, originalImg: imagePreview.image!, memeImg: memedImage);
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme);
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyBoard()
    {
        self.view.endEditing(true);
    }
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillbeHidden:"    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        
        var aRect:CGRect = self.view.frame;
        aRect.size.height  -= getKeyboardHeight(notification);
         if(!CGRectContainsPoint(aRect, activeField!.frame.origin))
         {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillbeHidden(notification: NSNotification)
    {
        self.view.frame.origin.y = CGRectZero.origin.y;
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func takeImage(sender: UIBarButtonItem) {
        getImage(1);
    }
    @IBAction func pickImage(sender: UIBarButtonItem) {
        getImage(2);
    }
    
    @IBAction func shareImg(sender: UIButton) {
        memedImage = generateMemedImage();
        let sharingObj:[UIImage] = [memedImage];
        let sharing:UIActivityViewController  = UIActivityViewController(activityItems: sharingObj, applicationActivities: nil);
        sharing.completionWithItemsHandler = {(activityType:String!, completed: Bool,
            returnedItems: [AnyObject]!, error: NSError!) in
            if(completed)
            {
                self.save();
                let destination = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarView") as! UITabBarController
                self.presentViewController(destination, animated: true, completion: nil);
            }
            }
         self.presentViewController(sharing, animated: true, completion: nil);
       
    }
    
    func getImage(type:Int)
    {
        let imagepicker = UIImagePickerController();
        imagepicker.delegate = self;
        if (type == 1)
        {
             imagepicker.sourceType = UIImagePickerControllerSourceType.Camera;
        }
        else if (type == 2)
        {
            imagepicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        }
        self.presentViewController(imagepicker, animated: true, completion: nil);
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.tempStr = textField.text;
        activeField = textField;
        textField.text = "";
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text == "")
        {
            textField.text = self.tempStr;
        }
        activeField = nil;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        hideKeyBoard();
        return true;
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("didn't pick any image");
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            shareBtn.enabled = true
            self.imagePreview.image = image;
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

