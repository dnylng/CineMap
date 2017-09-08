//
//  PosterImageView.swift
//  CineMap
//
//  Created by Danny Luong on 9/8/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class PosterImageView: UIImageView {

    override func awakeFromNib() {
        self.layoutIfNeeded()
        
        layer.cornerRadius = self.frame.height / 20.0
        layer.masksToBounds = true
    }

}
