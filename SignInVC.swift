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
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    @IBOutlet weak var stackView: UIStackView!

    
    var originalTopConstraint: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeIcon()
        
        emailField.delegate = self
        passField.delegate = self
        
        // Don't need to unregister since iOS 9
        registerKeyboardObservers()
        
        originalTopConstraint = topConstraint?.constant
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
    
    // Creates observers for keyboard coming up and down
    fileprivate func registerKeyboardObservers() {
        // Set up for moving text fields up
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    // When keyboard appears, move textfield up
    func keyboardWillShow(notification: NSNotification) {
        // When keyboard is up, change relation to equal to and move textfield up
        self.topConstraint?.isActive = false
        self.topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(self.topConstraint!)
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            // Move the whole stackview up
            self.topConstraint?.constant -= keyboardFrame.height
            
            // Animation the movement
            UIView.animate(withDuration: 0.25,
                           delay: TimeInterval(0),
                           options: UIViewAnimationOptions(rawValue: 7),
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // When keyboard is hidden, make sure top constraint is back to original
    func keyboardWillHide() {
        // When keyboard is down, switch to greater than and move textfield back down
        self.topConstraint?.isActive = false
        
        // Set top constraint back to original
        self.topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: originalTopConstraint)
        view.addConstraint(self.topConstraint!)
        
        // Animate the movement
        UIView.animate(withDuration: 0.25,
                       delay: TimeInterval(0),
                       options: UIViewAnimationOptions(rawValue: 7),
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }

}

