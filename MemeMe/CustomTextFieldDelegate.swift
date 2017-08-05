//
//  CustomTextFieldDelegate.swift
//  MemeMe
//
//  Created by Alessandro Bellotti on 23/05/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class CustomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "TOP" || textField.text! == "BOTTOM" {
            textField.text! = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text! = textField.text!.uppercased()
    }
}
