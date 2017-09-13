//
//  MovieCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/4/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK:- IBOUTLETS
    
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var planToWatchBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    // MARK:- VARIABLES
    
    private var statusButtons: [UIButton]!
    private var selectedStatus: Int!
    private var planToWatchMovies: [TMDBObject]!
    private var completedMovies: [TMDBObject]!
    
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
                    btn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
                } else {
                    btn.titleLabel!.font = UIFont(name: "AvenirNext-Regular", size: 12)
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
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 185/278
        let width = collectionView.frame.width / 3
        let height = width / ratio
        let size = CGSize(width: width, height: height)
        return size
    }

}
