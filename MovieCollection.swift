//
//  MovieCollection.swift
//  CineMap
//
//  Created by Danny Luong on 9/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class MovieCollection: TMDBCollection {

    // Loads up the collection array with TMDB's movie API
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionArraySetup(collection: Collection.movie)
    }

}
