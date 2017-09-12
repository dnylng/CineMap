//
//  CastCell.swift
//  CineMap
//
//  Created by Danny Luong on 9/11/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: PosterImageView!
    @IBOutlet weak var character: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        // Grab screen width: either iPhone SE, 7, or 7 Plus
        let screenWidth = UIScreen.main.bounds.width
        
        // Adjust font sizes depending on screen
        if screenWidth <= 320 {
            character.font = character.font.withSize(6)
            name.font = name.font.withSize(6)
        } else if screenWidth > 414 {
            character.font = character.font.withSize(10)
            name.font = name.font.withSize(10)
        } else {
            character.font = character.font.withSize(8)
            name.font = name.font.withSize(8)
        }
    }
    
}
