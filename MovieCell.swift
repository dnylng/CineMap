//
//  MovieCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/4/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import Firebase

class MovieCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK:- IBOUTLETS
    
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var planToWatchBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    // MARK:- VARIABLES
    
    // Array of status buttons
    private var statusButtons: [UIButton]!
    private var selectedStatus: Int!
    
    // Array of TMDBObjects that detail the movies the user has selected
    var planToWatch: [TMDBObject] = []
    var completed: [TMDBObject] = []
    
    private var cellId: String {
        get {
            if selectedStatus == 0 {
                return "PlanCell"
            } else {
                return "CompletedCell"
            }
        }
    }
    
    // MARK:- INITIALIZATION
    
    override func awakeFromNib() {
        setupTVCollection()
        setupStatusButtons()
        setupFontSizes()
        setupArrays()
    }
    
    // Populate the movie arrays with data from Firebase database
    fileprivate func setupArrays() {
        moviePlanToWatchRef.observe(.value, with: { snapshot in
            print("DANNY: movie snapshot's children count \(snapshot.childrenCount)")
            
            var tempArray: [TMDBObject] = []
            
            // Iterate through the snapshot's children to get imageUrls
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let child = child.value as! [String:Any]
                guard let id = child["id"] as? Int else { return }
                guard let imageUrl = child["imageUrl"] as? String else { return }
                let tmdbObject = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .movie)
                tempArray.append(tmdbObject)
            }
            
            self.planToWatch = tempArray
            self.movieCollection.reloadData()
        })
        
        movieCompletedRef.observe(.value, with: { snapshot in
            print("DANNY: snapshot's children count \(snapshot.childrenCount)")
            
            var tempArray: [TMDBObject] = []
            
            // Iterate through the snapshot's children to get imageUrls
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let child = child.value as! [String:Any]
                let id = child["id"] as! Int
                let imageUrl = child["imageUrl"] as! String
                let tmdbObject = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .movie)
                tempArray.append(tmdbObject)
            }
            
            self.completed = tempArray
            self.movieCollection.reloadData()
        })
    }
    
    fileprivate func setupFontSizes() {
        // Grab screen width: either iPhone SE, 7, or 7 Plus
        let screenWidth = UIScreen.main.bounds.width
        
        // Adjust font sizes depending on screen
        if screenWidth <= 320 {
            planToWatchBtn.titleLabel?.font = planToWatchBtn.titleLabel?.font.withSize(12)
            completedBtn.titleLabel?.font = completedBtn.titleLabel?.font.withSize(8)
        } else if screenWidth >= 414 {
            planToWatchBtn.titleLabel?.font = planToWatchBtn.titleLabel?.font.withSize(16)
            completedBtn.titleLabel?.font = completedBtn.titleLabel?.font.withSize(12)
        } else {
            planToWatchBtn.titleLabel?.font = planToWatchBtn.titleLabel?.font.withSize(14)
            completedBtn.titleLabel?.font = completedBtn.titleLabel?.font.withSize(10)
        }
    }
    
    fileprivate func setupTVCollection() {
        movieCollection.dataSource = self
        movieCollection.delegate = self
        movieCollection.allowsSelection = true
        
        if let flowLayout = movieCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    fileprivate func setupStatusButtons() {
        statusButtons = [planToWatchBtn, completedBtn]
        selectedStatus = statusButtons.index(of: planToWatchBtn)
        
    }
    
    // MARK:- STATUS BUTTON FUNCTIONS
    
    // Animates changing font sizes when button pressed
    fileprivate func changeFontSize(button: UIButton) {
        UIView.animate(withDuration: 0.75) {
            for btn in self.statusButtons {
                if btn == button {
                    if UIScreen.main.bounds.width <= 320 {
                        btn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
                    } else if UIScreen.main.bounds.width >= 414 {
                        btn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
                    } else {
                        btn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
                    }
                } else {
                    if UIScreen.main.bounds.width <= 320 {
                        btn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 8)
                    } else if UIScreen.main.bounds.width >= 414 {
                        btn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
                    } else {
                        btn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
                    }
                }
            }
        }
    }
    
    // Switch to plan to watch
    @IBAction func handlePlanToWatch(_ sender: Any) {
        selectedStatus = statusButtons.index(of: planToWatchBtn)
        changeFontSize(button: planToWatchBtn)
        
        UIView.transition(with: movieCollection,
                          duration: 0.50,
                          options: .transitionFlipFromTop,
                          animations: { self.movieCollection.reloadData() })
        
        print("DANNY: PLAN TO WATCH pressed")
    }
    
    // Switch to completed
    @IBAction func handleCompleted(_ sender: Any) {
        selectedStatus = statusButtons.index(of: completedBtn)
        changeFontSize(button: completedBtn)
        
        UIView.transition(with: movieCollection,
                          duration: 0.50,
                          options: .transitionFlipFromTop,
                          animations: { self.movieCollection.reloadData() })
        
        print("DANNY: COMPLETED pressed")
    }
    
    // MARK:- COLLECTION FUNCTIONS
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellId == "PlanCell" {
            return planToWatch.count
        } else {
            return completed.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EpisodeCell
        
        // Set the urlString depending on which array
        var urlString: String!
        if cellId == "PlanCell" {
            urlString = planToWatch[indexPath.item].imageUrl
            cell.tmdbObject = planToWatch[indexPath.item]
        } else {
            urlString = completed[indexPath.item].imageUrl
            cell.tmdbObject = completed[indexPath.item]
        }
        
        downloadImage(urlString: urlString, imageView: cell.imageView, collectionView: collectionView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 185/278
        
        var width: CGFloat!
        if cellId == "PlanCell" {
            if planToWatch.count > 27 {
                width = collectionView.frame.width / 4
            } else if planToWatch.count > 6 && planToWatch.count <= 27 {
                width = collectionView.frame.width / 3
            } else {
                width = collectionView.frame.width / 2
            }
        } else {
            if completed.count > 27 {
                width = collectionView.frame.width / 4
            } else if completed.count > 6 && completed.count <= 27 {
                width = collectionView.frame.width / 3
            } else {
                width = collectionView.frame.width / 2
            }
        }
        
        let height = width / ratio
        let size = CGSize(width: width, height: height)
        return size
    }

}
