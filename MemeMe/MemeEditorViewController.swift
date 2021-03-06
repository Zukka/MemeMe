//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Alessandro Bellotti on 23/05/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: IBOutlet
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeToolbar: UIToolbar!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var memeTabBar: UINavigationBar!
    
    // MARK: Variables
    var newMemedImage: UIImage!
    var memes = [Meme]()
    //  appAlertView show information to user in case of problem
    var appAlertView :UIAlertController?

    // MARK: Constants
    let textfieldDelegate = CustomTextFieldDelegate()
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedString.Key.strokeColor.rawValue: UIColor.black,
        NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
        NSAttributedString.Key.font.rawValue: UIFont(name: "Impact", size: 38)!,
        NSAttributedString.Key.strokeWidth.rawValue: -3.5]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraPickerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK : TextField funcs
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
        textField.textAlignment = .center
        textField.delegate = textfieldDelegate
    }

    // check if textfields are in editing mode for prevent a bad meme
    func checkTextfieldStatus() -> Bool{
        if topTextField.isEditing || bottomTextField.isEditing {
            return true
        }
        return false
    }

    // MARK : Menage show and hide keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        if self.bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) ->CGFloat {
        
        if let rect = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            return rect.cgRectValue.height
        } else {
            return CGFloat(0)
        }
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK : Pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imagePickerView.image = image
        } else{
            showAlertView(message: "Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromLibrary(_ sender: Any) {
        pick(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pick(sourceType: .camera)
    }
    
    func pick(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        self.shareMemeButton.isEnabled = true
    }
    
    // MARK : Build, share and save Meme
    @IBAction func shareMemePressed(_ sender: Any) {
        guard !checkTextfieldStatus() else {
            showAlertView(message: "textfield is in editing mode")
            return
        }
        self.newMemedImage = self.generateMemedImage()
        let controller = UIActivityViewController(activityItems: [newMemedImage as Any], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                // Save Meme
                self.saveMeme()
                // Here close Meme editor and display the list of sent memes
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func saveMeme() {
        // Create the meme
        let meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: newMemedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar
        hideBars(hide: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
        // Show toolbar
        hideBars(hide: false)
        return memedImage
    }
    
    // Hide and show TabBar and ToolBar
    func hideBars (hide: Bool) {
        memeToolbar.isHidden = hide
        memeTabBar.isHidden = hide
    }
    
    // Cancel Meme and reset to default
    @IBAction func cancelMemeCreation(_ sender: Any) {
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        imagePickerView.image = nil
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Alert
    func showAlertView(message: String) {
        
        appAlertView = UIAlertController(title: "MemeMe - Alert",
                                            message: message,
                                            preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Close", style: UIAlertAction.Style.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        appAlertView!.addAction(action)
        
        present(appAlertView!, animated: true, completion: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
