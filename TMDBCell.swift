//
//  TMDBCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/5/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class TMDBCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayHeight: NSLayoutConstraint?
    @IBOutlet weak var title: UILabel?
    
    var imageUrl: String!
    var id: Int!
    var tmdbType: TMDBType!
    
    override func awakeFromNib() {
        // Grab screen width: either iPhone SE, 7, or 7 Plus
        let screenWidth = UIScreen.main.bounds.width
        
        // Adjust font sizes depending on screen
        if screenWidth <= 320 {
            title?.font = title?.font.withSize(10)
        } else if screenWidth >= 414 {
            title?.font = title?.font.withSize(14)
        } else {
            title?.font = title?.font.withSize(12)
        }

    }
    
}
