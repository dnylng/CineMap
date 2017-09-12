//
//  SearchVC.swift
//  CineMap
//
//  Created by Danny Luong on 9/12/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITextFieldDelegate {

    // MARK:- IBOUTLETS
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchField: UITextField!
    
    // MARK:- VARIABLES
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPopup()
        
        searchField.delegate = self
    }
    
    // Sets the dimensions of the popup
    fileprivate func setupPopup() {
        // Grab screen width: either iPhone SE, 7, or 7 Plus
        let screenWidth = UIScreen.main.bounds.width
        
        // Set the height of icon depending on the phone
        if screenWidth <= 320 {
            widthConstraint.constant = 280
            heightConstraint.constant = 448
        } else if screenWidth >= 414 {
            widthConstraint.constant = 373
            heightConstraint.constant = 616
        } else {
            widthConstraint.constant = 335
            heightConstraint.constant = 547        }
    }
    
    // MARK:- DISMISS POPUP

    @IBAction func closePopup(_ sender: Any) {
        
    }
    
    // MARK:- KEYBOARD FUNCTIONS
    
    // User presses return key to remove keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
    
    // Hide keyboard when user touches outside of the keyboard
    @IBAction func closeKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
