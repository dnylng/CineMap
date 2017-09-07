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
    @IBOutlet weak var button: UIButton!
    
    var imageUrl: String!
    var id: Int!
    
}
