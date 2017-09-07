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

class HomeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var viewButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvButton: CustomButton!
    @IBOutlet weak var homeButton: CustomButton!
    @IBOutlet weak var movieButton: CustomButton!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    
    // MARK:- VARIABLES
    
    var viewButtons: [CustomButton]!
    var selectedButton: Int!
    
    let homeCell = "HomeCell"
    let tvCell = "TVCell"
    let movieCell = "MovieCell"
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeViewButtons()
        
        // Init the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
        }
        
        // Init the viewButtons array with our buttons
        viewButtons = [tvButton, homeButton, movieButton]
        selectedButton = viewButtons.index(of: homeButton)
        print("DANNY: Selected button is \(selectedButton!)")
        
        blurBackground.alpha = 0
    }
    
    // When view loads up, move to home view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Start the view at home
        scrollToViewIndex(index: 1)
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
        scrollToViewIndex(index: selectedButton)
    }
    
    @IBAction func handleHome(_ sender: Any) {
        moveSelectedImage(button: homeButton)
        
        selectedButton = 1
        scrollToViewIndex(index: selectedButton)
    }
    
    @IBAction func handleMovie(_ sender: Any) {
        moveSelectedImage(button: movieButton)

        selectedButton = 2
        scrollToViewIndex(index: selectedButton)
    }
    
    fileprivate func scrollToViewIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    // MARK:- VIEW CELL FUNCTIONS
    
    // Returns the number of cells there are
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // Returns the cell bahavior
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Make a reuseable cell
        var cell: UICollectionViewCell!
        
        // Return the view depending on the index
        switch indexPath.row {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: tvCell, for: indexPath)
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCell, for: indexPath)
        case 2:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCell, for: indexPath)
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCell, for: indexPath)
        }
        
        return cell
    }
    
    // Returns cell size which is the width/height of collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    // Handles scrolling functionality
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Get the x position of the current scrollview
        let x = scrollView.contentOffset.x
        
        // If on 1st cell, go to TV; if on 2nd cell, go to home; if on 3rd cell, go to movie
        switch x {
        case 0:
            handleTV(self)
            
        case collectionView.frame.width:
            handleHome(self)
            
        case collectionView.frame.width * 2:
            handleMovie(self)
            
        default:
            break
        }
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
    
    // MARK:- MORE INFORMATION FUNCTIONS
    
    @IBAction func handleInfo(_ sender: Any) {
        UIView.animate(withDuration: 0.50) {
            self.blurBackground.alpha = 1
        }
        
        performSegue(withIdentifier: "toInfo", sender: self)
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        UIView.animate(withDuration: 0.50) {
            self.blurBackground.alpha = 0
        }
    }
    
}
