//
//  ViewController.swift
//  CineMap
//
//  Created by Danny Luong on 8/29/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var emailField: IndentTextField!
    @IBOutlet weak var passField: IndentTextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var originalTopConstraint: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeIcon()
        
        emailField.delegate = self
        passField.delegate = self
        
        originalTopConstraint = topConstraint.constant
    }

    // From init, automatically resize icon for diff phone sizes
    fileprivate func resizeIcon() {
        // Grab screen width: either iPhone SE, 7, or 7 Plus
        let screenWidth = UIScreen.main.bounds.width
        
        // Set the height of icon depending on the phone
        if screenWidth <= 320 {
            iconHeight.constant = 105
            print("DANNY: iPhone SE, Icon Height: \(iconHeight.constant)")
        } else if screenWidth >= 414 {
            iconHeight.constant = 150
            print("DANNY: iPhone 7 Plus, Icon Height: \(iconHeight.constant)")
        } else {
            iconHeight.constant = 138
            print("DANNY: iPhone 7, Icon Height: \(iconHeight.constant)")
        }
    }
    
    // Hide keyboard when user touches outside of the keyboard
    @IBAction func closeKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // User presses return key to remove keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        return true
    }

}

