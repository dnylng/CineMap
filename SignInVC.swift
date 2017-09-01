//
//  ViewController.swift
//  CineMap
//
//  Created by Danny Luong on 8/29/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {
    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var emailField: IndentSignInFields!
    @IBOutlet weak var passField: IndentSignInFields!
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    @IBOutlet weak var stackView: UIStackView!

    // MARK:- VARIABLES
    
    var originalTopConstraint: CGFloat!
    var activeField: UITextField?
    
    // MARK:- INITIALIZATION FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeIcon()
        
        assignDelegates()
        
        // Save the original top constraint value
        originalTopConstraint = topConstraint?.constant
    }
    
    // Register observers, auto login
    override func viewDidAppear(_ animated: Bool) {
        // Auto login
        if Auth.auth().currentUser?.uid != nil {
            performSegue(withIdentifier: "toHomeFromSignIn", sender: self)
        } else {
            // User has to sign in
        }
        
        registerKeyboardObservers()
    }
    
    // Deregister observers
    override func viewDidDisappear(_ animated: Bool) {
        deregisterKeyboardObservers()
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
    
    // MARK:- KEYBOARD DELEGATE FUNCTIONS
    
    // Assigning textfield delegates
    fileprivate func assignDelegates() {
        emailField.delegate = self
        passField.delegate = self
        activeField?.delegate = self
    }
    
    // Detects which textfield being edited
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    // Set active textfield to nil when not editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    // User presses return key to remove keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passField.resignFirstResponder()
        return true
    }
    
    // Hide keyboard when user touches outside of the keyboard
    @IBAction func closeKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK:- KEYBOARD OBSERVER FUNCTIONS
    
    // Creates observers for keyboard coming up and down
    fileprivate func registerKeyboardObservers() {
        // Set up for moving text fields up
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Deletes keyboard observers
    fileprivate func deregisterKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // When keyboard appears, move textfield up
    func keyboardWillShow(notification: NSNotification) {
        // When keyboard is up, change relation to equal to and move textfield up
        self.topConstraint?.isActive = false
        self.topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: originalTopConstraint)
        view.addConstraint(self.topConstraint!)
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            print("DANNY: Keyboard height \(keyboardFrame.height)")
            
            // Calc distance from bottom to email field
            let origin = self.view.convert(view.frame.origin, from: activeField)
            let emailHeight = view.frame.maxY - ((activeField?.frame.height)! + origin.y)
            print("DANNY: Email height \(emailHeight)")
            
            // TODO: Fix behavior of going from bottom textfield and up
            
            // Move the whole stackview up
            self.topConstraint?.constant -= (keyboardFrame.height - emailHeight + 8)
            
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
    
    // MARK:- FIREBASE AUTHENTICATION
    
    @IBAction func toSignUp(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    // Handles what happens when user presses sign in
    @IBAction func handleSignIn(_ sender: Any) {
        // Form validation
        guard let email = emailField.text, let pass = passField.text else {
            print("DANNY: Email or password is not valid")
            return
        }
        
        // Sign into Firebase with email and password
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if error != nil {
                print("DANNY: \(error!)")
                return
            }
            
            print("DANNY: Successfully signed in with email and password")
            
            self.performSegue(withIdentifier: "toHomeFromSignIn", sender: self)
        }
    }

}

