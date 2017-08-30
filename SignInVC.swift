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
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeIcon()
        
        // Set up for text fields position adjustment
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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

    // When keyboard is hidden, make sure bot constraint is 0.0
    func keyboardWillHide() {
        self.topConstraint.constant = originalTopConstraint
        UIView.animate(withDuration: 0.25,
                       delay: TimeInterval(0),
                       options: UIViewAnimationOptions(rawValue: 7),
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    // When keyboard is shown, move the top constraint up
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            self.topConstraint.constant -= keyboardFrame.height
            UIView.animate(withDuration: 0.25,
                           delay: TimeInterval(0),
                           options: UIViewAnimationOptions(rawValue: 7),
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // Set the active textfield to the one being edited
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    // Set the active textfield to nothing if not being edited
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }

}

