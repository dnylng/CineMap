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
    
    private var viewButtons: [CustomButton]!
    private var selectedButton: Int = 1
    private var usedButton: Bool!
    
    let homeCell = "HomeCell"
    let tvCell = "TVCell"
    let movieCell = "MovieCell"
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeViewButtons()
        setupCollection()
        setupViewButtons()
        addSwipe()
        collectionView.isScrollEnabled = false
        
        blurBackground.alpha = 0
        usedButton = false
    }
    
    // Init the collection view
    fileprivate func setupCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
        }
    }

    // Init the viewButtons array with our buttons
    fileprivate func setupViewButtons() {
        viewButtons = [tvButton, homeButton, movieButton]
        selectedButton = viewButtons.index(of: homeButton)!
        print("DANNY: Selected button is \(selectedButton)")
    }
    
    fileprivate func addSwipe() {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(HomeVC.handleSwipe(sender:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
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
        if selectedButton == 2 {
            usedButton = true
        } else {
            usedButton = false
        }
        moveSelectedImage(button: tvButton)

        selectedButton = 0
        scrollToViewIndex(index: selectedButton)
        print("DANNY: selected button \(selectedButton)")
    }
    
    @IBAction func handleHome(_ sender: Any) {
        usedButton = false
        moveSelectedImage(button: homeButton)
        
        selectedButton = 1
        scrollToViewIndex(index: selectedButton)
        print("DANNY: selected button \(selectedButton)")
    }
    
    @IBAction func handleMovie(_ sender: Any) {
        if selectedButton == 0 {
            usedButton = true
        } else {
            usedButton = false
        }
        moveSelectedImage(button: movieButton)

        selectedButton = 2
        scrollToViewIndex(index: selectedButton)
        print("DANNY: selected button \(selectedButton)")
    }
    
    fileprivate func scrollToViewIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction.rawValue == 1 {
            // If swiped left
            selectedButton -= 1
            if selectedButton < 0 {
                selectedButton += 1
            }
            scrollToViewIndex(index: selectedButton)
            moveSelectedImage(button: viewButtons[selectedButton])
        } else {
            // If swiped right
            selectedButton += 1
            if selectedButton > 2 {
                selectedButton -= 1
            }
            scrollToViewIndex(index: selectedButton)
            moveSelectedImage(button: viewButtons[selectedButton])
        }
    }
    
    // MARK:- COLLECTION FUNCTIONS
    
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
        performSegue(withIdentifier: "toSearch", sender: self)
    }
    
    // MARK:- INFORMATION FUNCTIONS
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UIView.animate(withDuration: 0.50) {
            self.blurBackground.alpha = 0.80
        }
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        UIView.animate(withDuration: 0.50) {
            self.blurBackground.alpha = 0
        }
    }
    
}
