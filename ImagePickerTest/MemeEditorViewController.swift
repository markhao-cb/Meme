//
//  ViewController.swift
//  ImagePickerTest
//
//  Created by Yu Qi Hao on 3/13/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickFromCameraBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    var topString: String = "TOP"
    var bottomString: String = "BOTTOM"
    var originalImage: UIImage?
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -1.0
    ]
    
    //MARK: UIViewController Delegate Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setShareBtnTo(false)
        
        setupTextField(topTextField, defaultString: topString)
        setupTextField(bottomTextField, defaultString: bottomString)
        
        imagePickerView.contentMode = .ScaleAspectFit

        if let image = originalImage {
            imagePickerView.image = image
            setShareBtnTo(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Disable the camera button if camera is unavailable in the current device.
        pickFromCameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        //Subscribe keyboard notifications
        subscribeToKeyBoardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unsubscribe keyboard notifications
        unsubscribeToKeyBoardNotifications()
    }
    
    
    //MARK: UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Clear text before editing
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if  textField.text != "" {
            topTextField.isFirstResponder() ? (topString = textField.text!) : (bottomString = textField.text!)
        } else {
            topTextField.isFirstResponder() ? (topTextField.text = topString) : (bottomTextField.text = bottomString)
        }
        return true
    }
    
    
    //Dismiss keyboard on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: Button Selectors
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        presentImagePickerViewControllerBySourceType(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        presentImagePickerViewControllerBySourceType(.Camera)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if (completed) {
                self.save()
                self.dismissViewControllerAnimated(true, completion:nil)
            }
        }
    }
    

    @IBAction func resetEditor(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: ImagePIckerController Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            setShareBtnTo(true)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Keyboard Methods
    
    private func subscribeToKeyBoardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeToKeyBoardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    //MARK: Initialize Meme object
    func save() {
        
        //Create the Meme
        let newMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        //Add it to the memes array in the Application Delegate
        Utilities.appDelegate.memes.append(newMeme)
    }
    
    private func generateMemedImage() -> UIImage {
        
        //Hide Toolbar and Navbar
        toolBar.hidden = true
        navBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show Toolbar and Navbar
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    //MARK: Utility methods
    
    private func setupTextField(textField: UITextField, defaultString: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultString
        textField.textAlignment = .Center
    }
    
    private func setShareBtnTo(opt: Bool) {
        shareBtn.enabled = opt
    }
    
    private func presentImagePickerViewControllerBySourceType(souceType:UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = souceType
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

}

