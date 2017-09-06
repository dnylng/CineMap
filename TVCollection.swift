//
//  TVCollection.swift
//  CineMap
//
//  Created by Danny Luong on 9/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class TVCollection: TMDBCollection {

    // Loads up the collection array with TMDB's TV API
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionArraySetup(collection: Collection.tv)
    }

}
