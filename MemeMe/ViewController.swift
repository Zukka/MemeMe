//
//  ViewController.swift
//  MemeMe
//
//  Created by Alessandro Bellotti on 23/05/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    struct Meme {
        var topString: String
        var bottomString: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    var memes = [Meme]()
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    @IBOutlet weak var saveMemeButton: UIBarButtonItem!
    
    @IBOutlet weak var txt_top: UITextField!
    @IBOutlet weak var txt_bottom: UITextField!
    @IBOutlet weak var memeToolbar: UIToolbar!
    
    var newMemedImage: UIImage!
    
    let textfieldDelegate = CustomTextFieldDelegate()
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName: -1]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txt_bottom.text = "BOTTOM"
        self.txt_bottom.defaultTextAttributes = memeTextAttributes
        self.txt_bottom.textAlignment = .center
        self.txt_bottom.delegate = textfieldDelegate

        self.txt_top.text = "TOP"
        self.txt_top.defaultTextAttributes = memeTextAttributes
        self.txt_top.textAlignment = .center
        self.txt_top.delegate = textfieldDelegate
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardShowNotifications()
        subscribeToKeyboardHideNotification()
        cameraPickerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardShowNotifications()
        unsubscribeFromKeyboardHideNotification()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if self.txt_bottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0 // getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) ->CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
        
    }
    
    func subscribeToKeyboardShowNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardHideNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardShowNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardHideNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.saveMemeButton.isEnabled = true
        } else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromLibrary(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    // Generate meme and save
    @IBAction func buildMemePressed(_ sender: Any) {
        newMemedImage = generateMemedImage()
        saveMeme()
    }
    
    func saveMeme() {
        // Create the meme
        let meme = Meme(topString: txt_top.text!, bottomString: txt_bottom.text!, originalImage: imagePickerView.image!, memedImage: newMemedImage)
        memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar
        memeToolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
        // Show toolbar
        memeToolbar.isHidden = false
        return memedImage
    }


}

