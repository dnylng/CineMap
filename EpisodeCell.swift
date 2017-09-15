//
//  EpisodeCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/13/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    
    // MARK:- IBOUTLETS
    
    @IBOutlet weak var imageView: PosterImageView!
    @IBOutlet weak var overlayHeight: NSLayoutConstraint!
    @IBOutlet weak var episodeCount: UILabel!
    
    // MARK:- VARIABLES
    
    var tmdbObject: TMDBObject!
    
    // MARK:- EPISODE COUNT FUNCTIONS
    
    @IBAction func incrementCount(_ sender: Any) {
        tmdbObject.onEpisode += 1
        if tmdbObject.onEpisode > tmdbObject.numOfEpisodes - 1 {
            moveMovieToCompleted(self)
        } else {
            updateCurrentlyWatchingDB(tmdbObject: tmdbObject)
            print("DANNY: \(tmdbObject.id) ep count is now \(tmdbObject.onEpisode)")
        }
    }
    
    @IBAction func decrementCount(_ sender: Any) {
        tmdbObject.onEpisode -= 1
        if tmdbObject.onEpisode < 0 {
            tmdbObject.onEpisode += 1
        } else {
            let values: [String : Any] = ["onEpisode": tmdbObject.onEpisode]
            tvCurrentlyWatchingRef.child("\(tmdbObject.id)").updateChildValues(values)
            print("DANNY: \(tmdbObject.id) ep count is now \(tmdbObject.onEpisode)")
        }
    }

    @IBAction func moveMovieToCompleted(_ sender: Any) {
        if tmdbObject.tmdbType == .tv {
            //tvCurrentlyWatchingRef.child("\(tmdbObject.id)").removeAllObservers()
            //tvCurrentlyWatchingRef.child("\(tmdbObject.id)").child("\(tmdbObject.id)").removeAllObservers()
            //tvCurrentlyWatchingRef.child("\(tmdbObject.id)").child("imageUrl").removeAllObservers()
            //tvCurrentlyWatchingRef.child("\(tmdbObject.id)").child("numOfEpisodes").removeAllObservers()

            tvCurrentlyWatchingRef.child("\(tmdbObject.id)").removeValue()
            updateCompletedDB(tmdbObject: tmdbObject)
            print("DANNY: episode cell moved to tv completed \(tmdbObject.id)")
        } else {
            moviePlanToWatchRef.child("\(tmdbObject.id)").removeValue()
            updateCompletedDB(tmdbObject: tmdbObject)
            print("DANNY: episode cell moved to movie completed \(tmdbObject.id)")
        }
    }
    
}
