//
//  TVCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/4/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import Firebase

class TVCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var currentlyWatchingBtn: UIButton!
    @IBOutlet weak var planToWatchBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var tvCollection: UICollectionView!

    // MARK:- VARIABLES
    
    private var statusButtons: [UIButton]!
    private var selectedStatus: Int!
    
    private var currentlyWatching: [TMDBObject] = []
    private var planToWatch: [TMDBObject] = []
    private var completed: [TMDBObject] = []
    
    private var cellId: String {
        get {
            if selectedStatus == 0 {
                return "CurrentCell"
            } else if selectedStatus == 1 {
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
        tvCurrentlyWatchingRef.observe(.value, with: { snapshot in
            print("DANNY: tv snapshot's children count \(snapshot.childrenCount)")
            
            var tempArray: [TMDBObject] = []
            
            // Iterate through the snapshot's children to get imageUrls and episode count
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let child = child.value as! [String:Any]
                guard let id = child["id"] as? Int else { return }
                guard let imageUrl = child["imageUrl"] as? String else { return }
                guard let numOfEpisodes = child["numOfEpisodes"] as? Int else { return }
                guard let onEpisode = child["onEpisode"] as? Int else { return }
                let tmdbObject = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .tv, numOfEpisodes: numOfEpisodes, onEpisode: onEpisode)
                tempArray.append(tmdbObject)
            }
            
            self.currentlyWatching = tempArray
            self.tvCollection.reloadData()
        })
        
        tvPlanToWatchRef.observe(.value, with: { snapshot in
            print("DANNY: snapshot's children count \(snapshot.childrenCount)")
            
            var tempArray: [TMDBObject] = []
            
            // Iterate through the snapshot's children to get imageUrls
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let child = child.value as! [String:Any]
                let id = child["id"] as! Int
                let imageUrl = child["imageUrl"] as! String
                let numOfEpisodes = child["numOfEpisodes"] as! Int
                let tmdbObject = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .tv, numOfEpisodes: numOfEpisodes)
                tempArray.append(tmdbObject)
            }
            
            self.planToWatch = tempArray
            self.tvCollection.reloadData()
        })
        
        tvCompletedRef.observe(.value, with: { snapshot in
            print("DANNY: snapshot's children count \(snapshot.childrenCount)")
            
            var tempArray: [TMDBObject] = []
            
            // Iterate through the snapshot's children to get imageUrls
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? DataSnapshot {
                let child = child.value as! [String:Any]
                let id = child["id"] as! Int
                let imageUrl = child["imageUrl"] as! String
                let tmdbObject = TMDBObject(id: id, imageUrl: imageUrl, tmdbType: .tv)
                tempArray.append(tmdbObject)
            }
            
            self.completed = tempArray
            self.tvCollection.reloadData()
        })
    }
    
    fileprivate func setupFontSizes() {
        // Grab screen width: either iPhone SE, 7, or 7 Plus
        let screenWidth = UIScreen.main.bounds.width
        
        // Adjust font sizes depending on screen
        if screenWidth <= 320 {
            currentlyWatchingBtn.titleLabel?.font = currentlyWatchingBtn.titleLabel?.font.withSize(12)
            planToWatchBtn.titleLabel?.font = planToWatchBtn.titleLabel?.font.withSize(8)
            completedBtn.titleLabel?.font = completedBtn.titleLabel?.font.withSize(8)
        } else if screenWidth >= 414 {
            currentlyWatchingBtn.titleLabel?.font = currentlyWatchingBtn.titleLabel?.font.withSize(16)
            planToWatchBtn.titleLabel?.font = planToWatchBtn.titleLabel?.font.withSize(12)
            completedBtn.titleLabel?.font = completedBtn.titleLabel?.font.withSize(12)
        } else {
            currentlyWatchingBtn.titleLabel?.font = currentlyWatchingBtn.titleLabel?.font.withSize(14)
            planToWatchBtn.titleLabel?.font = planToWatchBtn.titleLabel?.font.withSize(10)
            completedBtn.titleLabel?.font = completedBtn.titleLabel?.font.withSize(10)
        }
    }
    
    fileprivate func setupTVCollection() {
        tvCollection.dataSource = self
        tvCollection.delegate = self
        tvCollection.allowsSelection = true
        
        if let flowLayout = tvCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
    }
    
    fileprivate func setupStatusButtons() {
        statusButtons = [currentlyWatchingBtn, planToWatchBtn, completedBtn]
        selectedStatus = statusButtons.index(of: currentlyWatchingBtn)
    }
    
    // MARK:- COLLECTION FUNCTIONS
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellId == "CurrentCell" {
            return currentlyWatching.count
        } else if cellId == "PlanCell" {
            return planToWatch.count
        } else {
            return completed.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EpisodeCell
        var urlString: String!

        if cellId == "CurrentCell" {
            cell.overlayHeight?.constant = cell.frame.height / 2 - 8
            urlString = currentlyWatching[indexPath.item].imageUrl
            cell.tmdbObject = currentlyWatching[indexPath.item]
            cell.tmdbObject.onEpisode = currentlyWatching[indexPath.item].onEpisode
            cell.episodeCount.text = "\(cell.tmdbObject.onEpisode)/\(cell.tmdbObject.numOfEpisodes)"
        } else if cellId == "PlanCell" {
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
        if cellId == "CurrentCell" {
            if currentlyWatching.count > 27 {
                width = collectionView.frame.width / 4
            } else if currentlyWatching.count > 6 && currentlyWatching.count <= 27 {
                width = collectionView.frame.width / 3
            } else {
                width = collectionView.frame.width / 2
            }
        } else if cellId == "PlanCell" {
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
    
    // Switch selected to currently watching
    @IBAction func handleCurrentlyWatching(_ sender: Any) {
        selectedStatus = statusButtons.index(of: currentlyWatchingBtn)
        changeFontSize(button: currentlyWatchingBtn)
        
        UIView.transition(with: tvCollection,
                          duration: 0.50,
                          options: .transitionFlipFromTop,
                          animations: { self.tvCollection.reloadData() })
        
        print("DANNY: CURRENTLY WATCHING pressed")
    }
    
    // Switch selected to plan to watch
    @IBAction func handlePlanToWatch(_ sender: Any) {
        selectedStatus = statusButtons.index(of: planToWatchBtn)
        changeFontSize(button: planToWatchBtn)
        
        UIView.transition(with: tvCollection,
                          duration: 0.50,
                          options: .transitionFlipFromTop,
                          animations: { self.tvCollection.reloadData() })
        
        print("DANNY: PLAN TO WATCH pressed")
    }
    
    // Switch selected to completed
    @IBAction func handleCompleted(_ sender: Any) {
        selectedStatus = statusButtons.index(of: completedBtn)
        changeFontSize(button: completedBtn)
        
        UIView.transition(with: tvCollection,
                          duration: 0.50,
                          options: .transitionFlipFromTop,
                          animations: { self.tvCollection.reloadData() })
        
        print("DANNY: COMPLETED pressed")
    }
}
