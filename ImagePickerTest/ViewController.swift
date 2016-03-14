//
//  ViewController.swift
//  ImagePickerTest
//
//  Created by Yu Qi Hao on 3/13/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var pickFromCameraBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareBtn: UIButton!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -1.0
    ]
    
    var textFieldFrame: CGRect?
    var viewFrameChanged = false
    
    
    //MARK: UIViewController Delegate Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .Center
        
        
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .Center
        
        
        imagePickerView.contentMode = .ScaleAspectFit
        
        shareBtn.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Disable the camera button if camera is unavailable in the current device.
        pickFromCameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Subscribe keyboard notifications
        subscribeToKeyBoardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unscribe keyboard notifications
        unsubscribeToKeyBoardNotifications()
    }
    
    
    //MARK: UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textFieldFrame = textField.frame
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Clear text before editing
        textField.text = ""
    }
    
    
    //Dismiss keyboard on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: Button Selectors
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (!completed) {
                return
            }
            
            //activity complete
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        
        
    }
    

    @IBAction func resetEditor(sender: AnyObject) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareBtn.enabled = false
    }
    
    
    //MARK: ImagePIckerController Delegate Methods
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            shareBtn.enabled = true
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
        
        let keyboardHeight = getKeyboardHeight(notification)
        
        if let frame = textFieldFrame {
            if frame.origin.y + frame.size.height > self.view.frame.height - keyboardHeight {
                self.view.frame.origin.y -= keyboardHeight
                viewFrameChanged = true
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if viewFrameChanged {
            self.view.frame.origin.y += getKeyboardHeight(notification)
            viewFrameChanged = false
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
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    private func generateMemedImage() -> UIImage {
        
        //Hide Toolbar and Navbar
        toolBar.hidden = true
        navigationController?.navigationBarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show Toolbar and Navbar
        toolBar.hidden = false
        navigationController?.navigationBarHidden = false
        
        return memedImage
    }

}

