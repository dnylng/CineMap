//
//  HomeVC.swift
//  CineMap
//
//  Created by Danny Luong on 8/31/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class HomeVC: UIViewController {
    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var viewButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvButton: CustomButton!
    @IBOutlet weak var homeButton: CustomButton!
    @IBOutlet weak var movieButton: CustomButton!
    @IBOutlet weak var selectedImage: UIImageView!
    
    // MARK:- VARIABLES
    
    var viewButtons: [CustomButton]!
    var selectedButton: Int!
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeViewButtons()
        
        // Init the viewButtons array with our buttons
        viewButtons = [tvButton, homeButton, movieButton]
        selectedButton = viewButtons.index(of: homeButton)
        print("DANNY: Selected button is \(selectedButton!)")
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    // MARK:- SELECTED VIEW FUNCTIONS
    
    // This will update the current constraint on the selected image
    fileprivate func moveSelectedImage(button: UIButton) {
        // Turn off the constraint and change it to match up with another button
        selectedImageConstraint.isActive = false
        selectedImageConstraint = NSLayoutConstraint(item: selectedImage, attribute: .leading, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1.0, constant: -16.5)
        view.addConstraint(selectedImageConstraint)
        
        // Animate with a curve ease out
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func handleTV(_ sender: Any) {
        moveSelectedImage(button: tvButton)

        selectedButton = 0
    }
    
    @IBAction func handleHome(_ sender: Any) {
        moveSelectedImage(button: homeButton)
        
        selectedButton = 1
    }
    
    @IBAction func handleMovie(_ sender: Any) {
        moveSelectedImage(button: movieButton)

        selectedButton = 2
    }
    
    // MARK:- NAVIGATION BAR FUNCTIONS
    
    fileprivate func resizeViewButtons() {
        let screen = UIScreen.main.bounds
        viewButtonHeight.constant = screen.width / 12
        print("DANNY: View button height \(viewButtonHeight.constant)")
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        // Dismiss this view
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
        
        do {
            try Auth.auth().signOut()
            FBSDKLoginManager().logOut()
            GIDSignIn.sharedInstance().signOut()
        } catch let error {
            print("DANNY: \(error)")
        }
        
        print("DANNY: Logged out")
    }

    @IBAction func handleSearch(_ sender: Any) {
        // TODO: Implement search function
    }
}
