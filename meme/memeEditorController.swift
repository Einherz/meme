//
//  ViewController.swift
//  meme
//
//  Created by Amorn Apichattanakul on 4/25/15.
//  Copyright (c) 2015 amorn. All rights reserved.
//

import UIKit


class memeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var topTxt: UITextField!
    @IBOutlet weak var bottomTxt: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    private var meme: MemeObj!;
    private var memedImage: UIImage!;
    private var tempStr: String?;
    private var activeField: UITextField?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set TextField
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0 // this is might be a weird bug of Apple, I've found it on stackoverflow that you can't use positive value sometimes?
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
        //useful feature to tap
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
        //hide navigation bar and tool bar
        self.navigationBar.hidden = true;
        self.toolBar.hidden = true;
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
       //show Navigation bar and toolbar
        self.navigationBar.hidden = false;
        self.toolBar.hidden = false;
        
        return memedImage
    }
    
    func save() {
        //Create the meme
        meme = MemeObj(textMeme: topTxt.text,subTextMeme: bottomTxt.text, originalImg: imagePreview.image!, memeImg: memedImage);
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme);
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        // force keyboard to hide
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyBoard()
    {
        // force keyboard to hide
        self.view.endEditing(true);
    }
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillbeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        
        //change from Udacity to Apple Style.
        //I have used it a lot in my application
        //Udacity solution is shift everything up 
        //even keyboard doesnot overlap TextField
        //Apple style is checking if keyboard DID overlap then shift up
        var aRect: CGRect = self.view.frame;
        aRect.size.height  -= getKeyboardHeight(notification);
         if(!CGRectContainsPoint(aRect, activeField!.frame.origin))
         {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
         }
    }
    
    func keyboardWillbeHidden(notification: NSNotification)
    {
        //return view back to zero position
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
        let sharingObj: [UIImage] = [memedImage];
        let sharing: UIActivityViewController  = UIActivityViewController(activityItems: sharingObj, applicationActivities: nil);
        sharing.completionWithItemsHandler = {(activityType:String!, completed: Bool,
            returnedItems: [AnyObject]!, error: NSError!) in
            if(completed)
            {
                self.save();
                let destination = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarView") as! UITabBarController
                self.presentViewController(destination, animated: true, completion: nil);
            }
        };
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
        //clear text that was filled and save in tempStr
        self.tempStr = textField.text;
        activeField = textField;
        textField.text = "";
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //if value in textfield is exist will delete it
        // and if value is nill then refill it back from textFieldDidBeginEditing
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

