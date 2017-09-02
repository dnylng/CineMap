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
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeViewButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {

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
