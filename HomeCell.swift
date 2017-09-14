//
//  HomeCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/4/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var popularTVLabel: UILabel!
    @IBOutlet weak var popularMovieLabel: UILabel!
    @IBOutlet weak var airingLabel: UILabel!
    
    override func awakeFromNib() {
        let width = UIScreen.main.bounds.width
        
        if width <= 320 {
            popularTVLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
            popularMovieLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
            airingLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        } else if width >= 414 {
            popularTVLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
            popularMovieLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
            airingLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        } else {
            popularTVLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
            popularMovieLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
            airingLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)
        }
    }

}
