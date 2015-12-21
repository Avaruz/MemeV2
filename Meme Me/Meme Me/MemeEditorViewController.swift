//
//  MemeEditorViewController
//  Meme Me V2
//
//  Created by Adhemar Soria Galvarro on 12/10/15.
//  Copyright © 2015 Adhemar Soria Galvarro. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var shareImageButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UIToolbar!
    
    var memeImage : UIImage!
    
    let meme1Delegate = MemeTextFieldDelegate()
    let meme2Delegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    
    }
    
    func setupUI() {
        topText.delegate =  meme1Delegate
        bottomText.delegate = meme2Delegate
        resetAll()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        let memeTextAttributes = [ NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSFontAttributeName:UIFont(name: "Impact", size: 40)!,
            NSStrokeWidthAttributeName:-3.0]
        
        topText.defaultTextAttributes=memeTextAttributes
        bottomText.defaultTextAttributes=memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
        topText.textAlignment = NSTextAlignment.Center
        topText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func resetAll(){
        shareImageButton.enabled = false
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
        
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        shareImageButton.enabled = false
        memeImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)

        
        activityController.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
 
    }
    
    @IBAction func pickingImageFrom(sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        let buttonPress = sender as UIBarButtonItem
        pickerController.delegate=self
        
        if buttonPress.tag==1 {
            pickerController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
            
        }else
        {
            pickerController.sourceType=UIImagePickerControllerSourceType.Camera
            
        }
    
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelAndBack(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
          moveView(Directions.up,notification: notification)
        }
        
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            moveView(Directions.down,notification: notification)
        }
    }
    
    func moveView(direction: Directions, notification: NSNotification)
    {
        let keyboardHeight = getKeyboardHeight(notification)
        let y = view.frame.origin.y
        let newY = y + (keyboardHeight * CGFloat(direction.rawValue))
        //sometimes the keyboard don't show and the top is increase without need
        view.frame.origin.y = (newY<=0 ? newY : y)
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image=info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image=image
            shareImageButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func save() {
        
       let meme = Meme(
        topTextField: topText.text,
        bottomTextField: bottomText.text,
        originalImage: imageView.image,
        memedImage: memeImage)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        toolBar.hidden = true
        navBar.hidden = true
        
        //this trick make that imageView fill all the parent view
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
 
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //back to the normal view
        imageView.contentMode = UIViewContentMode.ScaleToFill
        
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
        
    }
    

}
