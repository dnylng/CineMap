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
    
    // MARK:- EPISODE COUNT FUNCTIONS
    
    @IBAction func incrementCount(_ sender: Any) {
        
    }
    
    @IBAction func decrementCount(_ sender: Any) {
        
    }
}
