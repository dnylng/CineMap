//
//  InfoVC.swift
//  CineMap
//
//  Created by Danny Luong on 9/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import TMDBSwift

// Public variable that determines which movie/tv show was selected
var selectedCellId: Int!
var selectedCellImage: UIImage!
var selectedCellType: TMDBType!

class InfoVC: UIViewController {

    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var infoSummary: UITextView!
    @IBOutlet weak var castCollection: UICollectionView!
    
    // MARK:- VARIABLES
    
    
    // MARK:- INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("DANNY: \(selectedCellId)")
        print("DANNY: \(selectedCellImage)")
        print("DANNY: \(selectedCellType)")
        
        setupInfo()
    }
    
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
            heightConstraint.constant = 547
        }
    }
    
    // MARK:- INFORMATION DISPLAY
    
    fileprivate func setupInfo() {
        infoImage.image = selectedCellImage
        
        // Depending on TMDB data type, grab from respective TMDBSwift calls
        if selectedCellType == .tv {
            // Grab
            TVMDB.tv(TMDB_API_KEY, tvShowID: selectedCellId, language: language, completion: { (clientReturn, tvShow) in
                self.infoTitle.text = tvShow?.name
                self.infoSummary.text = tvShow?.overview
            })
        } else if selectedCellType == .movie {
            MovieMDB.movie(TMDB_API_KEY, movieID: selectedCellId, completion: { (clientReturn, movie) in
                self.infoTitle.text = movie?.title
                self.infoSummary.text = movie?.overview
            })
        }
    }
    
    @IBAction func planToWatch(_ sender: Any) {
    }
    
    @IBAction func currentlyWatching(_ sender: Any) {
    }
    
    @IBAction func completed(_ sender: Any) {
    }
    
}
