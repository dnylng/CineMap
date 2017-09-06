//
//  AiringCollection.swift
//  CineMap
//
//  Created by Danny Luong on 9/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class AiringCollection: TMDBCollection {

    // Loads up the collection array with TMDB's discover API
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionArraySetup(collection: Collection.airing)
    }

}
