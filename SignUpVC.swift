//
//  SignUpVC.swift
//  CineMap
//
//  Created by Danny Luong on 8/30/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {

    // MARK:- IBOUTLETS
    
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var firstNameField: IndentSignUpfields!
    @IBOutlet weak var lastNameField: IndentSignUpfields!
    @IBOutlet weak var emailField: IndentSignUpfields!
    @IBOutlet weak var passField: IndentSignUpfields!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK:- VARIABLES
    
    private var originalTopConstraint: CGFloat!
    private var activeField: UITextField?
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeIcon()
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passField.delegate = self
        activeField?.delegate = self
        
        originalTopConstraint = topConstraint?.constant
    }
    
    // Register observers
    override func viewDidAppear(_ animated: Bool) {
        registerKeyboardObservers()
    }
    
    // Deregister observers
    override func viewDidDisappear(_ animated: Bool) {
        deregisterKeyboardObservers()
        clearTextfields()
    }
    
    // MARK:- HELPER FUNCTIONS
    
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
    
    fileprivate func clearTextfields() {
        firstNameField.text = ""
        lastNameField.text = ""
        emailField.text = ""
        passField.text = ""
    }
    
    // MARK:- KEYBOARD DELEGATE FUNCTIONS
    
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
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
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
    
    @IBAction func cancelSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Makes an account w/ email and password in DB
    @IBAction func handleSignUp(_ sender: Any) {
        // Validate email and pass inputs
        guard let email = emailField.text, let password = passField.text, let firstName = firstNameField.text, let lastName = lastNameField.text else {
            print("Missing first name, last name, email or password input")
            return
        }
        
        // Create the user in Firebase if it doesn't exist
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("DANNY: \(error!)")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            createUserInDB(uid: uid, firstName: firstName, lastName: lastName, email: email)
            
            // Dismiss this VC
            self.dismiss(animated: true, completion: {
                // Go to the Home screen
                self.performSegue(withIdentifier: "toHomeFromSignUp", sender: self)
            })
        }
    }
}
